//
//  ListChaptersServiceTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import XCTest
import MangaDexResponse
@testable import MangaReader

final class ListChaptersServiceTest: XCTestCase {

    var apiService: Requestable!
    var sut: ListChaptersServing!


    override func setUp() {
        apiService = nil
        sut = nil
    }
    
    override func tearDown() {
        apiService = nil
        sut = nil
    }
    
    func test_fetch_list_chapters() async throws {
        apiService = APIServiceMock(mockType: .listManga)
        sut = ListChaptersService(apiService: apiService)
        
        let result = try await sut.fetchChapters(mangaId: "", limit: 50, offset: 0, ascending: true)
        XCTAssert(result.count > 0)
    }
    
    func test_response_not_return_manga_model_array() async throws {
        apiService = APIServiceMock(mockType: .mangaDetail)
        sut = ListChaptersService(apiService: apiService)
        do {
            let result = try await sut.fetchChapters(mangaId: "", limit: 50, offset: 0, ascending: true)
        } catch {
            if let err = error as? MangaReaderError, case .backendError(let mangaDexErrorStruct) = err {
                XCTAssert(true)
                return
            }

        }
        XCTFail("it should return a backend error")

        
    }

}
