//
//  PokemonListViewModel.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {
    @Published var pokemonNames: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let useCase: GetPokemonListUseCase
    private let coordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()
    private var currentOffset = 0
    
    init(useCase: GetPokemonListUseCase, coordinator: AppCoordinator) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
    
    func loadPokemon() {
        isLoading = true
        errorMessage = nil
        
        useCase.execute(offset: currentOffset)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] names in
                    self?.pokemonNames = names
                    self?.currentOffset += 20
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshPokemon() {
        currentOffset = 0
        loadPokemon()
    }
    
    func selectPokemon(at index: Int) {
        let name = pokemonNames[index]
        coordinator.showPokemonDetail(withName: name)
    }
}
