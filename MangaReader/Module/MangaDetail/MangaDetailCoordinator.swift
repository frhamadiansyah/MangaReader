//
//  MangaDetailCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 31/08/24.
//

import SwiftUI
import MangaDexResponse
import DependencyContainer
import FavoriteStorage

final class MangaDetailCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(with manga: MangaModel) -> UIViewController {
        let dataManager = DC.shared.resolve(type: .singleInstance, for: FavoriteDataManagerProtocol.self)
        
        let viewModel = MangaDetailViewModel(manga: manga, favoriteManager: dataManager, onCreatorSelected: pushCreatorDetail(_ :), onChaptersSelecter: pushShowChapters(_ :))
        let view = MangaDetailView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: view)
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        return hostingVC
    }

    func pushCreatorDetail(_ model: CreatorModel) {

    }
    
    func pushShowChapters(_ model: MangaModel) {
        let coordinator = ListChaptersCoordinator(navigationController: navigationController)
        let new = coordinator.makeViewController(with: model)
        navigationController?.pushViewController(new, animated: true)
    }
}
