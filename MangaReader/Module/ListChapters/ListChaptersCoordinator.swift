//
//  ListChaptersCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import SwiftUI
import MangaDexResponse
import DependencyContainer
import FavoriteStorage


final class ListChaptersCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(with manga: MangaModel) -> UIViewController {
        let service = ListChaptersService(apiService: APIService())
        let viewModel = ListChaptersViewModel(manga: manga, service: service, onChapterSelected: pushChapter(_ :))
        let view = ListChaptersView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: view)
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        return hostingVC
    }
    
    func pushChapter(_ manga: ChapterModel) {
//        let coordinator = MangaDetailCoordinator(navigationController: navigationController)
//        let new = coordinator.makeViewController(with: manga)
//        navigationController?.pushViewController(new, animated: true)
    }
}
