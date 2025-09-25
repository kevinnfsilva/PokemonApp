//
//  PokemonDetailViewModel.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: Pokemon?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let pokemonName: String
    private let useCase: GetPokemonDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemonName: String, useCase: GetPokemonDetailUseCase) {
        self.pokemonName = pokemonName
        self.useCase = useCase
        loadPokemonDetails()
    }
    
    private func loadPokemonDetails() {
        isLoading = true
        errorMessage = nil
        
        useCase.execute(name: pokemonName.lowercased())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] detailedPokemon in
                    self?.pokemonDetail = detailedPokemon 
                }
            )
            .store(in: &cancellables)
    }
    
    func retry() {
        loadPokemonDetails()
    }
}
