//
//  SettingsCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 26/09/24.
//

import SwiftUI

final class SettingsCoordinator {

    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func makeViewController() -> UIViewController {
        let viewModel = SettingsViewModel()
        let settingsView = SettingsView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: settingsView)
        hostingVC.navigationItem.largeTitleDisplayMode = .never
        navigationController.setViewControllers([hostingVC], animated: false)
        navigationController.navigationItem.largeTitleDisplayMode = .inline
        hostingVC.title = "Settings"
        return navigationController
    }
}
