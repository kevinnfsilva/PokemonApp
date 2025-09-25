//
//  APIEndPoint.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation

enum APIEndpoint {
    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(name: String)
    
    private var baseURL: String {
        return "https://pokeapi.co/api/v2"
    }
    
    private var path: String {
        switch self {
        case .pokemonList(let limit, let offset):
            return "/pokemon?limit=\(limit)&offset=\(offset)"
        case .pokemonDetail(let name):
            return "/pokemon/\(name)"
        }
    }
    
    var url: URL? {
        return URL(string: baseURL + path)
    }
}
