//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 12/09/24.
//

import Foundation
import CoreData

public class FavoriteDataManager: FavoriteDataManagerProtocol {
    
    public func fetchAllFavoriteMangaId() async throws -> [String] {
        let request = NSFetchRequest<FavoriteMangaEntity>(entityName: "FavoriteMangaEntity")
        
        let sort = NSSortDescriptor(keyPath: \FavoriteMangaEntity.created_at, ascending: true)
        request.sortDescriptors = [sort]
        return try await manager.context.perform {
            return try request.execute().compactMap({$0.manga_id})
        }
    }
    
    public func addFavorite(mangaId: String) async throws  {
        let fav = FavoriteMangaEntity(context: manager.context)
        fav.manga_id = mangaId
        fav.created_at = Date()
        try await manager.save()

    }

    
    public func removeFavorites(withId: String) async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteMangaEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "manga_id = %@", withId)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try await manager.context.perform { [weak self] in
            _ = try self?.manager.container.viewContext.execute(batchDeleteRequest)
        }

    }
    
    public func clearAllFavorites() async throws {
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
    
    public init () {
        self.manager = CoreDataManager.shared
        
//        testSetup()
    }
    
    func testSetup() {
        //MARK: Remove after implement search feature
        Task {
            try? await addFavorite(mangaId:"b73371d4-02dd-4db0-b448-d9afa3d698f1")
            try? await addFavorite(mangaId:"6b27cbd8-4cc6-40ca-b010-928da4540be8")
            try? await addFavorite(mangaId:"32fdfe9b-6e11-4a13-9e36-dcd8ea77b4e4")
            try? await addFavorite(mangaId:"87ffa375-bd2c-49ba-ba0c-6d78ea07c342")
            try? await addFavorite(mangaId:"e83c326b-921b-45ff-bc0c-d667bbfe64cc")
        }
    }
    
}
