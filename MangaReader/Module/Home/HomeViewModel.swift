//
//  HomeViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 02/09/24.
//

import SwiftUI
import MangaDexResponse

final class HomeViewModel: ObservableObject {

    @Published var mangas = [MangaModel]()
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false

    private let homeService: HomeServing
    private let favoriteManager: FavoriteDataManagerProtocol
    private let onMangaSelected: (MangaModel) -> Void
    private var didCallOnAppearForTheFirstTime = false
    private var favorites: [FavoriteMangaEntity] = []

    init(homeService: HomeServing, favoriteManager: FavoriteDataManagerProtocol, onMangaSelected: @escaping (MangaModel) -> Void) {
        self.homeService = homeService
        self.favoriteManager = favoriteManager
        self.onMangaSelected = onMangaSelected
    }

    func onAppear() {
        guard didCallOnAppearForTheFirstTime == false else {
            return
        }
        didCallOnAppearForTheFirstTime = true
        fetchFavoriteMangas()
    }

    func didSelectManga(_ manga: MangaModel) {
        onMangaSelected(manga)
    }
    

    private func fetchFavoriteMangas() {
        let limit = 50
        let offset = 0
        Task { @MainActor in
            do {
                favorites = try await favoriteManager.fetchAllFavorite()
                
                let favoriteMangas = favorites.compactMap({$0.manga_id})
                
                mangas = try await homeService.fetchFavoriteManga(favoriteMangaIds: favoriteMangas, limit: limit, offset: offset)
                
            } catch {
                if let err = error as? MangaReaderError {
                    homeError = err
                }
            }
        }
    }
    
    func removeFavoriteManga(manga: MangaModel) {
        let mangaIdToBeRemoved = manga.id
        if let entity = favorites.first(where: { entity in
            return entity.manga_id == mangaIdToBeRemoved
        }) {
            Task { @MainActor in
                do{
                    try await favoriteManager.removeFavorite(favoriteMangaEntity: entity)
                    
                    favorites.removeAll { entity in
                        return entity.manga_id == mangaIdToBeRemoved
                    }
                    
                    mangas.removeAll { model in
                        return model.id == manga.id
                    }
                } catch {
                    if let err = error as? MangaReaderError {
                        homeError = err
                    }
                }
            }
            
        }
    }
}
