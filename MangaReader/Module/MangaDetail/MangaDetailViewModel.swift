//
//  MangaDetailViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import SwiftUI
import MangaDexResponse
import FavoriteStorage

final class MangaDetailViewModel: ObservableObject {
    
    private let favoriteManager: FavoriteDataManagerProtocol
    
    private let onCreatorSelected: (CreatorModel) -> Void
    private let onChaptersSelected: (MangaModel) -> Void
    private var didCallOnAppearForTheFirstTime = false
    
    let manga: MangaModel
    @Published var isFavoriteManga: Bool = false
    
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false
    
    init(manga: MangaModel, favoriteManager: FavoriteDataManagerProtocol, onCreatorSelected: @escaping (CreatorModel) -> Void, onChaptersSelecter: @escaping (MangaModel) -> Void) {
        self.favoriteManager = favoriteManager
        self.manga = manga
        self.onCreatorSelected = onCreatorSelected
        self.onChaptersSelected = onChaptersSelecter
    }
    
    func fetchIsFavoriteValue() {
        Task { @MainActor in
            isFavoriteManga = await checkIfMangaIsFavorite()
        }
    }
    
    func checkIfMangaIsFavorite() async -> Bool {
        do {
            let result = try await favoriteManager.checkIfFavoriteManga(mangaId: manga.id)
            return result
        } catch {
            if let err = error as? MangaReaderError {
                homeError = err
                showError.toggle()
            }
        }
        return isFavoriteManga
    }
    
    func favoriteButtonPressed() async -> Bool {
        do {
            if isFavoriteManga {
                try await favoriteManager.removeFavorites(withId: manga.id)
                return false
            } else {
                try await favoriteManager.addFavorite(mangaId: manga.id)
                return true
            }
        } catch {
            if let err = error as? MangaReaderError {
                homeError = err
                showError.toggle()
            }
        }
        return isFavoriteManga
    }
    
    func favoriteButtonPressedUpdateValue() {
        Task { @MainActor in
            isFavoriteManga = await favoriteButtonPressed()
        }
        
    }
    
    func openChapters() {
        onChaptersSelected(manga)
    }
}
