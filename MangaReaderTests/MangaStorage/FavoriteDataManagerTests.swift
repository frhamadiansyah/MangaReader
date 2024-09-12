//
//  FavoriteDataManagerTests.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 11/09/24.
//

import XCTest
import CoreData
@testable import MangaReader

final class FavoriteDataManagerTests: XCTestCase {
    
    var sut: FavoriteDataManager!
    
    override func setUp() {
        sut = FavoriteDataManager(manager: CoreDataManager(storageType: .inMemory))
    }
    

    func test_add_new_favorite_manga() async throws {
        let context = sut.manager.context

        try await sut.addFavorite(mangaId: "manga_id", mangaTitle: "manga_title")
        
        //When
        let fetchRequest: NSFetchRequest<FavoriteMangaEntity> = FavoriteMangaEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        let finalProduct1 = result?.first
        //Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(finalProduct1?.manga_id, "manga_id")
    }
    
    func test_fetch_favorite_mangas() async throws {
        let context = sut.manager.context

        try await sut.addFavorite(mangaId: "manga_id", mangaTitle: "manga_title")
        try await sut.addFavorite(mangaId: "manga_id_2", mangaTitle: "manga_title_second")
        try await sut.addFavorite(mangaId: "manga_id_3", mangaTitle: "manga_title_third")
        
        //When
        let result = try await sut.fetchAllFavorite()

        //Then
        XCTAssertEqual(result.count, 3)
        
        XCTAssertEqual(result.first?.manga_id, "manga_id")
        XCTAssertEqual(result.last?.manga_id, "manga_id_3")
    }
    
    func test_clear_all_favorite_mangas() async throws {
        let context = sut.manager.context

        try await sut.addFavorite(mangaId: "manga_id", mangaTitle: "manga_title")
        try await sut.addFavorite(mangaId: "manga_id_2", mangaTitle: "manga_title_second")
        try await sut.addFavorite(mangaId: "manga_id_3", mangaTitle: "manga_title_third")
        
        //When
        try await sut.clearAllFavorites()
        let result = try await sut.fetchAllFavorite()

        //Then
        XCTAssertEqual(result.count, 0)
    }
    
    func test_remove_favorite_manga() async throws {
        let context = sut.manager.context

        let first = try await sut.addFavorite(mangaId: "manga_id", mangaTitle: "manga_title")
        try await sut.addFavorite(mangaId: "manga_id_2", mangaTitle: "manga_title_second")
        try await sut.addFavorite(mangaId: "manga_id_3", mangaTitle: "manga_title_third")
        
        //When
        
        try await sut.removeFavorite(favoriteMangaEntity: first)
        
        let result = try await sut.fetchAllFavorite()

        //Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.manga_id, "manga_id_2")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
