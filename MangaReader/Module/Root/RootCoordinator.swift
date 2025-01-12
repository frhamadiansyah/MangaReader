//
//  RootCoordinator.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import UIKit

final class RootCoordinator {

    func makeInitialView() -> UIViewController {
        let homeView = HomeCoordinator().makeViewController()
        
        let searchView = SearchMangaCoordinator().makeViewController()
        
        let settingsView = SettingsCoordinator().makeViewController()
        
        let tabBarController = RootTabBarController(viewControllers: [homeView, searchView, settingsView])
        return tabBarController
    }
}
