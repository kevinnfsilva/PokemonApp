//
//  GetPokemonListUseCaseTests.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import XCTest
import Combine
@testable import PokemonApp

final class GetPokemonListUseCaseTests: XCTestCase {
    var sut: GetPokemonListUseCase!
    var mockRepository: MockPokemonRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonRepository()
        sut = GetPokemonListUseCase(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testExecute_Success() {
        // Given
        let expectedPokemon = ["pikachu", "charizard", "blastoise"]
        mockRepository.pokemonListResult = .success(expectedPokemon)
        
        let expectation = XCTestExpectation(description: "Use case executed successfully")
        
        // When
        sut.execute(limit: 20, offset: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion {
                        XCTFail("Expected success but got failure")
                    }
                },
                receiveValue: { pokemonList in
                    // Then
                    XCTAssertEqual(pokemonList, expectedPokemon)
                    XCTAssertEqual(self.mockRepository.lastLimit, 20)
                    XCTAssertEqual(self.mockRepository.lastOffset, 0)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_Failure() {
        // Given
        let expectedError = NetworkError.networkError(URLError(.notConnectedToInternet))
        mockRepository.pokemonListResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Use case failed as expected")
        
        // When
        sut.execute(limit: 20, offset: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Then
                        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected failure but got success")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Expected failure but got success")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testExecute_UsesDefaultValues() {
        // Given
        mockRepository.pokemonListResult = .success(["pokemon"])
        
        let expectation = XCTestExpectation(description: "Use case uses default values")
        
        // When
        sut.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in
                    // Then
                    XCTAssertEqual(self.mockRepository.lastLimit, 20)
                    XCTAssertEqual(self.mockRepository.lastOffset, 0)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockPokemonRepository: PokemonRepository {
    var pokemonListResult: Result<[String], NetworkError> = .success([])
    var pokemonDetailResult: Result<Pokemon, NetworkError> = .success(
        Pokemon(id: 1, name: "Test", imageURL: "", height: 10, weight: 10, types: [])
    )
    
    var lastLimit: Int = 0
    var lastOffset: Int = 0
    var lastPokemonName: String = ""
    
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[String], NetworkError> {
        lastLimit = limit
        lastOffset = offset
        
        switch pokemonListResult {
        case .success(let pokemon):
            return Just(pokemon)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func getPokemonDetail(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        lastPokemonName = name
        
        switch pokemonDetailResult {
        case .success(let pokemon):
            return Just(pokemon)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
