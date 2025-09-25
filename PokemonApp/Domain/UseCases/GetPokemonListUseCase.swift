//
//  GetPokemonListUseCase.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

class GetPokemonListUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(limit: Int = 20, offset: Int = 0) -> AnyPublisher<[String], NetworkError> {
        return repository.getPokemonList(limit: limit, offset: offset)
    }
}
