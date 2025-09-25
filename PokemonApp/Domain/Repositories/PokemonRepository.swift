//
//  PokemonRepository.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

protocol PokemonRepository {
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[String], NetworkError>
    func getPokemonDetail(name: String) -> AnyPublisher<Pokemon, NetworkError>
}
