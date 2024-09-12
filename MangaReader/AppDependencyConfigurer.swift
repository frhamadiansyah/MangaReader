//
//  AppDependencyConfigurer.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 10/09/24.
//

import Foundation
import DependencyContainer

enum AppDependencyConfigurer {
    
    static func configure() {
        let coreDataManager = CoreDataManager()
        DC.shared.register(type: .singleInstance(coreDataManager), for: CoreDataManager.self)
        
        
        let favoriteManager = FavoriteDataManager(manager: coreDataManager)
        
        
        DC.shared.register(type: .singleInstance(favoriteManager), for: FavoriteDataManagerProtocol.self)
        
        DC.shared.register(type: .closureBased({
            HomeService(apiService: APIService())
        }), for: HomeServing.self)
        
//        Task {
////            try? await favoriteManager.clearAllFavorites()
//            try? await favoriteManager.addFavorite(mangaId:"b73371d4-02dd-4db0-b448-d9afa3d698f1", mangaTitle:"ASDASDA")
//            try? await favoriteManager.addFavorite(mangaId:"6b27cbd8-4cc6-40ca-b010-928da4540be8", mangaTitle:"ASDASDA")
//            try? await favoriteManager.addFavorite(mangaId:"32fdfe9b-6e11-4a13-9e36-dcd8ea77b4e4", mangaTitle:"ASDASDA")
//            try? await favoriteManager.addFavorite(mangaId:"87ffa375-bd2c-49ba-ba0c-6d78ea07c342", mangaTitle:"ASDASDA")
//            try? await favoriteManager.addFavorite(mangaId:"e83c326b-921b-45ff-bc0c-d667bbfe64cc", mangaTitle:"ASDASDA")
//
//        }
        
    }
    
}