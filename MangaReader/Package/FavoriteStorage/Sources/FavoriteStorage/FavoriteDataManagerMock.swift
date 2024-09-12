//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 12/09/24.
//

import Foundation

public class FavoriteDataManagerMock: FavoriteDataManagerProtocol {
    public func fetchAllFavoriteMangaId() async throws -> [String] {
        return []
    }
    
    public func addFavorite(mangaId: String) async throws {
        
    }
    
    public func removeFavorites(withId: String) async throws {
        
    }
    
    public func clearAllFavorites() async throws {
        
    }
    
    public init() {}
}
