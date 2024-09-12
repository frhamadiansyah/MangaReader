//
//  RootTabBarController.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import UIKit

final class RootTabBarController: UITabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        setViewControllers(viewControllers, animated: false)
        updateTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func updateTabBar() {
        guard let items = tabBar.items else {
            return
        }
        
        let firstItem = items[0]
        firstItem.title = "ms_tabbar_home_title"
        firstItem.image = UIImage(systemName: "house")
        
        let secondItem = items[1]
        secondItem.title = "ms_tabbar_home_title"
        secondItem.image = UIImage(systemName: "checkmark")
    }
}
