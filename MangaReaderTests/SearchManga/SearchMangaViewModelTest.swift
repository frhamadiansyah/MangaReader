//
//  SearchMangaViewModelTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 14/09/24.
//

import XCTest
import MangaDexResponse
import FavoriteStorage
@testable import MangaReader

final class SearchMangaViewModelTest: XCTestCase {
    

    func test_search_manga_returns_correct() async {
        let expectation = expectation(description: "fetch_favorites")

        let sut = makeSUT(mockType: .listManga, expectation: expectation) { _ in
            
        }
        
        //setup add favorite
        sut.searchText = "manga"
        sut.searchManga()
        
        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        XCTAssert(sut.mangas.count == 10, "got count \(sut.mangas.count)")
        XCTAssert(testId == "425f2ccf-581f-42cf-aed3-c3312fcde926", "testId is wrong, I got \(testId)")
    }
    
    func test_search_manga_returns_false() async {
        let expectation = expectation(description: "fetch_favorites")

        let sut = makeSUT(mockType: .listChapter, expectation: expectation) { _ in
            
        }
        
        //setup add favorite
        sut.searchText = "manga"
        sut.searchManga()
        
        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        
        XCTAssertNotNil(sut.homeError, "no error found")
        XCTAssert(sut.mangas.count == 0, "got count \(sut.mangas.count)")
    }
    
    func test_search_manga_searchText_empty() async {

        let sut = makeSUT(mockType: .listManga, expectation: nil) { _ in
            
        }
        
        //setup add favorite
        sut.searchText = ""
        sut.searchManga()
        
//        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        XCTAssert(sut.mangas.count == 0, "got count \(sut.mangas.count)")
    }
    
    
    
    private func makeSUT(mockType: MockDataType, expectation: XCTestExpectation?, onMangaSelected: @escaping (MangaModel) -> Void) -> SearchMangaViewModel {
        
        var service = APIServiceMock(mockType: mockType)
        service.fetchMangasExpectation = expectation
        let searchService = SearchMangaService(apiService: service)
        let sut = SearchMangaViewModel(service: searchService) { manga in
            onMangaSelected(manga)
        }
        return sut
    }

}
