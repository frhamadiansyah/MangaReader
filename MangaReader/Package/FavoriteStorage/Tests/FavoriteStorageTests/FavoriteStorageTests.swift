import XCTest
import CoreData
@testable import FavoriteStorage

final class FavoriteStorageTests: XCTestCase {
    
    var sut: FavoriteDataManager!
    
    override func setUp() {
        sut = FavoriteDataManager(manager: CoreDataManager(storageType: .inMemory))
    }
    

    func test_add_new_favorite_manga() async throws {
        let context = sut.manager.context

        try await sut.addFavorite(mangaId: "manga_id")
        
        //When
        let fetchRequest: NSFetchRequest<FavoriteMangaEntity> = FavoriteMangaEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        let finalProduct1 = result?.first
        //Then
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(finalProduct1?.manga_id, "manga_id")
    }
    
    func test_fetch_favorite_mangas() async throws {
        try await sut.addFavorite(mangaId: "manga_id")
        try await sut.addFavorite(mangaId: "manga_id_2")
        try await sut.addFavorite(mangaId: "manga_id_3")
        
        //When
        let result = try await sut.fetchAllFavoriteMangaId()

        //Then
        XCTAssertEqual(result.count, 3)
        
        XCTAssertEqual(result.first, "manga_id")
        XCTAssertEqual(result.last, "manga_id_3")
    }
    
    func test_clear_all_favorite_mangas() async throws {
        try await sut.addFavorite(mangaId: "manga_id")
        try await sut.addFavorite(mangaId: "manga_id_2")
        try await sut.addFavorite(mangaId: "manga_id_3")
        
        //When
        try await sut.clearAllFavorites()
        let result = try await sut.fetchAllFavoriteMangaId()

        //Then
        XCTAssertEqual(result.count, 0)
    }

    
    func test_remove_favorite_manga_with_id() async throws {
        try await sut.addFavorite(mangaId: "manga_id")
        try await sut.addFavorite(mangaId: "manga_id_2")
        try await sut.addFavorite(mangaId: "manga_id_3")
        
        //When
        
        try await sut.removeFavorites(withId: "manga_id")
        
        let result = try await sut.fetchAllFavoriteMangaId()

        //Then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first, "manga_id_2")
    }
}
