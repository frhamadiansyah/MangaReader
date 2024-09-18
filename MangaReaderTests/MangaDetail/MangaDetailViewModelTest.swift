//
//  MangaDetailViewModelTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 14/09/24.
//

import XCTest
import MangaDexResponse
import FavoriteStorage
@testable import MangaReader

final class MangaDetailViewModelTest: XCTestCase {

    func test_check_if_manga_favorite_returns_false() async {
        let manga = MangaModel(id: "manga_id_new", title: "title", description: "desc")

        let favorite = FavoriteDataManager(forTesting: true)
        try? await favorite.addFavorite(mangaId:"manga_id")

        let sut = MangaDetailViewModel(manga: manga, favoriteManager: favorite, onCreatorSelected: { model in
            
        }, onChaptersSelecter: {model in
            
        })
        
        //setup add favorite
        let result = await sut.checkIfMangaIsFavorite()
        
        XCTAssert(result == false)

    }
    
    func test_check_if_manga_favorite_returns_true() async {
        let manga = MangaModel(id: "manga_id", title: "title", description: "desc")

        let favorite = FavoriteDataManager(forTesting: true)
        try? await favorite.addFavorite(mangaId:"manga_id")

        let sut = MangaDetailViewModel(manga: manga, favoriteManager: favorite) { model in
            
        } onChaptersSelecter: { manga in
        }
        
        //setup add favorite
        let result = await sut.checkIfMangaIsFavorite()
        
        XCTAssert(result == true)

    }
    
    func test_toggle_favorite_manga_to_false() async {
        let manga = MangaModel(id: "manga_id", title: "title", description: "desc")

        let favorite = FavoriteDataManager(forTesting: true)
        try? await favorite.addFavorite(mangaId:"manga_id")

        let sut = MangaDetailViewModel(manga: manga, favoriteManager: favorite) { model in
            
        } onChaptersSelecter: { manga in
            
        }
        
        //setup add favorite
        let buttonPressed = await sut.favoriteButtonPressed()
        let result = await sut.checkIfMangaIsFavorite()
        
        
        XCTAssert(result == buttonPressed)

    }
    
    func test_toggle_favorite_manga_to_true() async {
        let manga = MangaModel(id: "manga_id_new", title: "title", description: "desc")

        let favorite = FavoriteDataManager(forTesting: true)
        try? await favorite.addFavorite(mangaId:"manga_id")

        let sut = MangaDetailViewModel(manga: manga, favoriteManager: favorite) { model in
            
        } onChaptersSelecter: {manga in
        }
        
        //setup add favorite
        let buttonPressed = await sut.favoriteButtonPressed()
        let result = await sut.checkIfMangaIsFavorite()
        
        
        XCTAssert(result == buttonPressed)

    }

}
