//
//  PokemonRepositoryImpl.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

final class PokemonRepositoryImpl: PokemonRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[String], NetworkError> {
        let endpoint = APIEndpoint.pokemonList(limit: limit, offset: offset)
        return networkService.request(endpoint, type: PokemonListResponse.self)
            .map { $0.results.map { $0.name } }
            .eraseToAnyPublisher()
    }
    
    func getPokemonDetail(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        let endpoint = APIEndpoint.pokemonDetail(name: name)
        return networkService.request(endpoint, type: PokemonDetailResponse.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
