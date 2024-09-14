//
//  SearchMangaServiceTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 14/09/24.
//

import XCTest
import MangaDexResponse
@testable import MangaReader

final class SearchMangaServiceTest: XCTestCase {

    var apiService: Requestable!
    var sut: SearchMangaServing!


    override func setUp() {
        apiService = nil
        sut = nil
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    
    func test_fetch_favorite_list() async throws {
        apiService = APIServiceMock(mockType: .listManga)
        sut = SearchMangaService(apiService: apiService)
        
        let result = try await sut.searchMangaByTitle(title: "ok", limit: 50, offset: 0)
        XCTAssert(result.count > 0)
    }
    
    func test_response_not_return_manga_model_array() async throws {
        apiService = APIServiceMock(mockType: .mangaDetail)
        sut = SearchMangaService(apiService: apiService)
        do {
            let result = try await sut.searchMangaByTitle(title: "ok", limit: 50, offset: 0)
        } catch {
            if let err = error as? MangaReaderError, case .backendError(let mangaDexErrorStruct) = err {
                XCTAssert(true)
                return
            }

        }
        XCTFail("it should return a backend error")

        
    }

}
