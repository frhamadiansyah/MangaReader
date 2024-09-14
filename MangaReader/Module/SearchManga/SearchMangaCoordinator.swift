//
//  SearchMangaCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import SwiftUI
import MangaDexResponse
import DependencyContainer
import FavoriteStorage


final class SearchMangaCoordinator {

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func makeViewController() -> UIViewController {
        let service = DC.shared.resolve(type: .closureBased, for: SearchMangaServing.self)

        let viewModel = SearchMangaViewModel(service: service, onMangaSelected: pushMangaDetail(_ :))
        let searchView = SearchMangaView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: searchView)
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        navigationController.setViewControllers([hostingVC], animated: false)
        navigationController.navigationItem.largeTitleDisplayMode = .inline
        return navigationController
    }
    
    func pushMangaDetail(_ manga: MangaModel) {
        let coordinator = MangaDetailCoordinator(navigationController: navigationController)
        let new = coordinator.makeViewController(with: manga)
        navigationController.pushViewController(new, animated: true)
    }
}
