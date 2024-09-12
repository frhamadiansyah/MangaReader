//
//  MangaDetailCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 31/08/24.
//

import SwiftUI
import MangaDexResponse

final class MangaDetailCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(with manga: MangaModel) -> UIViewController {
        let viewModel = HomeViewModel(homeService: HomeService(apiService: APIService()), favoriteManager: FavoriteDataManager(manager: CoreDataManager()), onMangaSelected: {_ in})
        let view = HomeView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: view)
        hostingVC.title = manga.title
        return hostingVC
    }

//    private func pushMangaDetail(withIdentifier id: String) {
//        let gateway =
//        let view = gateway.makeArtistDetailModule(navigationController: navigationController, artistIdentifier: id)
//        navigationController?.pushViewController(view, animated: true)
//    }
}
