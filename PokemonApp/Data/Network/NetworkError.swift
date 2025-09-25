//
//  NetworkError.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "A URL da requisição é inválida. Tente novamente."
        case .networkError:
            return "Falha na conexão com a internet. Verifique sua rede e tente novamente."
        case .decodingError:
            return "Não foi possível processar a resposta do servidor. Tente novamente mais tarde."
        case .unknownError:
            return "Ocorreu um erro inesperado. Por favor, tente novamente."
        }
    }
}
