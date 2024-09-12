//
//  HomeServiceTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 04/09/24.
//

import XCTest
import MangaDexResponse
@testable import MangaReader


final class HomeServiceTest: XCTestCase {

    var apiService: Requestable!
    var sut: HomeServing!


    override func setUp() {
        apiService = nil
        sut = nil
//        apiService = APIServiceMock(mockType: .listManga)
//        sut = HomeService(apiService: apiService)
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    
    func test_fetch_favorite_list() async throws {
        apiService = APIServiceMock(mockType: .listManga)
        sut = HomeService(apiService: apiService)
        let result = try await sut.fetchFavoriteManga(favoriteMangaIds: [], limit: 50, offset: 0)
        XCTAssert(result.count > 0)
    }
    
    func test_response_not_return_manga_model_array() async throws {
        apiService = APIServiceMock(mockType: .mangaDetail)
        sut = HomeService(apiService: apiService)
        do {
            let result = try await sut.fetchFavoriteManga(favoriteMangaIds: [], limit: 50, offset: 0)
        } catch {
            if let err = error as? MangaReaderError, case .backendError(let mangaDexErrorStruct) = err {
                XCTAssert(true)
                return
            }

        }
        XCTFail("it should return a backend error")

        
    }

}
