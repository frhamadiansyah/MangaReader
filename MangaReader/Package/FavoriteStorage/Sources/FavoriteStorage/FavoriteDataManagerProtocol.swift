//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 12/09/24.
//

import Foundation

public protocol FavoriteDataManagerProtocol {
    func fetchAllFavoriteMangaId() async throws -> [String]
    func addFavorite(mangaId: String) async throws
    func removeFavorites(withId: String) async throws
    func clearAllFavorites() async throws
    func checkIfFavoriteManga(mangaId: String) async throws -> Bool
}
