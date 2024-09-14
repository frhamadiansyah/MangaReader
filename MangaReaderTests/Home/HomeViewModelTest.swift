//
//  HomeViewModelTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import XCTest
import MangaDexResponse
import FavoriteStorage
@testable import MangaReader

final class HomeViewModelTest: XCTestCase {
    
    func test_fetch_favorites_manga() async {
        let expectation = expectation(description: "fetch_favorites")
        
        var service = APIServiceMock(mockType: .listManga)
        service.fetchMangasExpectation = expectation
        let homeService = HomeService(apiService: service)
        let favorite = FavoriteDataManager(forTesting: true)
        await addDummyFavorites(manager: favorite)
        let sut = HomeViewModel(homeService: homeService, favoriteManager: favorite) { manga in
            
        }
        
        //setup add favorite
        sut.onAppear()
        
        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        XCTAssert(sut.mangas.count == 10, "got count \(sut.mangas.count)")
        XCTAssert(testId == "425f2ccf-581f-42cf-aed3-c3312fcde926", "testId is wrong, I got \(testId)")
    }
    
    func test_fetch_mangas_return_error() async {
        let expectation = expectation(description: "fetch_favorites")
        
        var service = APIServiceMock(mockType: .mangaDetail)
        service.fetchMangasExpectation = expectation
        let homeService = HomeService(apiService: service)
        let favorite = FavoriteDataManager(forTesting: true)
        await addDummyFavorites(manager: favorite)
        let sut = HomeViewModel(homeService: homeService, favoriteManager: favorite) { manga in
            
        }
        
        //setup add favorite
        sut.onAppear()
        
        await fulfillment(of: [expectation])
        XCTAssertNotNil(sut.homeError)
        XCTAssert(sut.showError)
    }
    
    func test_navigate_to_manga_detail() async {
        let expectation = XCTestExpectation(description: "fav")
        
        var service = APIServiceMock(mockType: .listManga)
        service.fetchMangasExpectation = expectation
        let homeService = HomeService(apiService: service)
        let favorite = FavoriteDataManager(forTesting: true)
        await addDummyFavorites(manager: favorite)
        
        var destination: MangaModel? = nil
        
        let sut = HomeViewModel(homeService: homeService, favoriteManager: favorite) { manga in
            destination = manga
            
        }
        //setup add favorite
        sut.onAppear()
        
        await fulfillment(of: [expectation])
        if let navigateDestination = sut.mangas.first {
            sut.didSelectManga(navigateDestination)
            XCTAssert(destination?.id == navigateDestination.id)
        } else {
            XCTFail("manga list empty")
        }
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func addDummyFavorites(manager: FavoriteDataManagerProtocol) async {
        try? await manager.clearAllFavorites()
        try? await manager.addFavorite(mangaId:"425f2ccf-581f-42cf-aed3-c3312fcde926")

    }

}
