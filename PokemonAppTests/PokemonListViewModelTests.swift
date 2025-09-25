import XCTest
import Combine
@testable import PokemonApp

final class PokemonListViewModelTests: XCTestCase {
    var sut: PokemonListViewModel!
    var mockUseCase: MockGetPokemonListUseCase!
    var mockCoordinator: MockAppCoordinator!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetPokemonListUseCase()
        mockCoordinator = MockAppCoordinator()
        sut = PokemonListViewModel(useCase: mockUseCase, coordinator: mockCoordinator)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadPokemon_Success() {
        // Given
        let expectedPokemon = ["pikachu", "charizard", "blastoise"]
        mockUseCase.result = .success(expectedPokemon)
        
        let expectation = XCTestExpectation(description: "Pokemon loaded successfully")
        
        // When
        sut.$pokemonNames
            .dropFirst()
            .sink { pokemonNames in
                XCTAssertEqual(pokemonNames, expectedPokemon)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.loadPokemon()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testLoadPokemon_Failure() {
        // Given
        let expectedError = NetworkError.networkError(URLError(.notConnectedToInternet))
        mockUseCase.result = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Pokemon loading failed")
        
        // When
        sut.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadPokemon()
        
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.pokemonNames.isEmpty)
    }
    
    func testSelectPokemon_CallsCoordinator() {
        // Given
        let pokemonNames = ["pikachu", "charizard"]
        sut.pokemonNames = pokemonNames
        
        // When
        sut.selectPokemon(at: 0)
        
        // Then
        XCTAssertTrue(mockCoordinator.showPokemonDetailCalled)
        XCTAssertEqual(mockCoordinator.lastPokemonNameShown, "pikachu")
    }
    
    func testRefreshPokemon_ResetsOffset() {
        // Given
        mockUseCase.result = .success(["pokemon1"])
        sut.loadPokemon()
        
        // When
        sut.refreshPokemon()
        
        // Then
        XCTAssertEqual(mockUseCase.lastOffset, 0)
    }
}

// MARK: - Mocks
class MockGetPokemonListUseCase: GetPokemonListUseCase {
    var result: Result<[String], NetworkError> = .success([])
    var lastLimit: Int = 0
    var lastOffset: Int = 0
    
    init() {
        let dummyRepository = MockPokemonRepository()
        super.init(repository: dummyRepository)
    }
    
    override func execute(limit: Int = 20, offset: Int = 0) -> AnyPublisher<[String], NetworkError> {
        lastLimit = limit
        lastOffset = offset
        
        return Future { promise in
            DispatchQueue.main.async {
                promise(self.result)
            }
        }
        .eraseToAnyPublisher()
    }
}

class MockAppCoordinator: AppCoordinator {
    var showPokemonDetailCalled = false
    var lastPokemonNameShown: String?
    
    init() {
        let dummyWindow = UIWindow()
        super.init(window: dummyWindow)
    }
    
    override func showPokemonDetail(withName name: String) {
        showPokemonDetailCalled = true
        lastPokemonNameShown = name
    }
}
