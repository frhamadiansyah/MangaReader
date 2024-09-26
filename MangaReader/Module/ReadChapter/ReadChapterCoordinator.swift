//
//  ReadChapterCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 19/09/24.
//

import SwiftUI
import MangaDexResponse
import DependencyContainer


final class ReadChapterCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(with chapter: ChapterModel) -> UIViewController {
        let service = ReadChapterService(apiService: APIService())
        let viewModel = ReadChapterViewModel(chapter: chapter, service: service)
        let view = ReadChapterView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: view)
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        return hostingVC
    }
    
}
