//
//  HomeCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import SwiftUI
import MangaDexResponse
import DependencyContainer

final class HomeCoordinator {

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func makeViewController() -> UIViewController {
        
        let service = DC.shared.resolve(type: .closureBased, for: HomeServing.self)
        let dataManager = DC.shared.resolve(type: .singleInstance, for: FavoriteDataManagerProtocol.self)
        
        let viewModel = HomeViewModel(homeService: service, favoriteManager: dataManager, onMangaSelected: pushMangaDetail(_ :))
        let homeView = HomeView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingVC], animated: false)
        return navigationController
    }
    
    func pushMangaDetail(_ manga: MangaModel) {
        let coordinator = MangaDetailCoordinator(navigationController: navigationController)
        let new = coordinator.makeViewController(with: manga)
        navigationController.pushViewController(new, animated: true)
    }
}

final class SearchCoordinator {

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func makeViewController() -> UIViewController {
        let viewModel = HomeViewModel(homeService: HomeService(apiService: APIService()), favoriteManager: FavoriteDataManager(manager: CoreDataManager()), onMangaSelected: {_ in })
        let homeView = HomeView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingVC], animated: false)
        return navigationController
    }
}
