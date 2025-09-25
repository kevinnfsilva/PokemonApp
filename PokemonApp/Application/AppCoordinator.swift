//
//  AppCoordinator.swift
//  PokemonApp
//
//  Created by kevin on 25/09/25.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    private let networkService: NetworkServiceProtocol
    private let pokemonRepository: PokemonRepository
    
    init(window: UIWindow) {
        self.window = window
        self.networkService = NetworkService()
        self.pokemonRepository = PokemonRepositoryImpl(networkService: self.networkService) 
    }
    
    func start() {
        let useCase = GetPokemonListUseCase(repository: pokemonRepository)
        let viewModel = PokemonListViewModel(useCase: useCase, coordinator: self)
        let pokemonListVC = PokemonListViewController(viewModel: viewModel)
        
        navigationController = UINavigationController(rootViewController: pokemonListVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showPokemonDetail(withName name: String) {
        let useCase = GetPokemonDetailUseCase(repository: pokemonRepository)
        let viewModel = PokemonDetailViewModel(pokemonName: name, useCase: useCase)
        let detailVC = PokemonDetailViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
