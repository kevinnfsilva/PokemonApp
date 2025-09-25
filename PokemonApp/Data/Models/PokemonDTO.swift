//
//  PokemonDTO.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonBasic]
}

struct PokemonBasic: Codable {
    let name: String
    let url: String
}

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [TypeElement]
}

struct Sprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeElement: Codable {
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
}

extension PokemonDetailResponse {
    func toDomain() -> Pokemon {
        return Pokemon(
            id: id,
            name: name.capitalized,
            imageURL: sprites.frontDefault ?? "",
            height: height,
            weight: weight,
            types: types.map { $0.type.name.capitalized }
        )
    }
}
