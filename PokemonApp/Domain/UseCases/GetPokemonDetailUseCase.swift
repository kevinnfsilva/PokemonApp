//
//  GetPokemonDetailUseCase.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

class GetPokemonDetailUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(name: String) -> AnyPublisher<Pokemon, NetworkError> {
        return repository.getPokemonDetail(name: name)
    }
}
