//
//  FavoriteDataManager.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 11/09/24.
//

import Foundation
import CoreData

protocol FavoriteDataManagerProtocol {
    func fetchAllFavorite() async throws -> [FavoriteMangaEntity]
    func addFavorite(mangaId: String, mangaTitle: String) async throws -> FavoriteMangaEntity
    func removeFavorite(favoriteMangaEntity: FavoriteMangaEntity) async throws
    func clearAllFavorites() async throws
}

class FavoriteDataManager: FavoriteDataManagerProtocol {
    
    func fetchAllFavorite() async throws -> [FavoriteMangaEntity] {
        let request = NSFetchRequest<FavoriteMangaEntity>(entityName: "FavoriteMangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \FavoriteMangaEntity.created_at, ascending: true)
        request.sortDescriptors = [sort]
        return try await manager.context.perform {
            return try request.execute()
        }
    }
    
    @discardableResult
    func addFavorite(mangaId: String, mangaTitle: String) async throws -> FavoriteMangaEntity {
        let fav = FavoriteMangaEntity(context: manager.context)
        fav.manga_id = mangaId
        fav.manga_title = mangaTitle
        fav.created_at = Date()
        
        try await manager.save()
        
        return fav
    }
    
    func removeFavorite(favoriteMangaEntity: FavoriteMangaEntity) async throws {
        manager.delete(favoriteMangaEntity)
        try await manager.save()
    }
    
    func clearAllFavorites() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteMangaEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try await manager.context.perform { [weak self] in
            _ = try self?.manager.container.viewContext.execute(batchDeleteRequest)
        }

    }
    
    let manager: CoreDataManager
    
    init(manager: CoreDataManager) {
        self.manager = manager
    }
    
}
