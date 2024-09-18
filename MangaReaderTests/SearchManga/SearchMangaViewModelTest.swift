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
        sut.newQueryMangaSearch()
        
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
        sut.newQueryMangaSearch()
        
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
        sut.newQueryMangaSearch()
        
//        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        XCTAssert(sut.mangas.count == 0, "got count \(sut.mangas.count)")
    }
    
    func test_scroll_to_bottom_of_list() async {
        let expectation = expectation(description: "fetch_favorites")

        let sut = makePrefilledSUT(mockType: .listManga, expectation: expectation) { _ in
            
        }
        
        //setup add favorite
        sut.searchText = "manga"

        
        let lastItemId = "6e445564-d9a8-4862-bff1-f4d6be6dba2c"
        sut.loadMoreIfNeeded(mangaId: lastItemId)
        
        await fulfillment(of: [expectation])
        let testId = sut.mangas.first?.id
        
        XCTAssert(sut.mangas.count == 20, "got count \(sut.mangas.count)")
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
    
    private func makePrefilledSUT(mockType: MockDataType, expectation: XCTestExpectation?, onMangaSelected: @escaping (MangaModel) -> Void) -> SearchMangaViewModel {
        
        var service = APIServiceMock(mockType: mockType)
        service.fetchMangasExpectation = expectation
        let searchService = SearchMangaService(apiService: service)
        let sut = SearchMangaViewModel(service: searchService) { manga in
            onMangaSelected(manga)
        }
        let response = try? MockData.fetchMockResponse(mockType: mockType)
        var array = [MangaModel]()
        if case .collection(let mangas) = response?.data {
            let result = mangas.compactMap { manga in
                let model = MangaModel(manga)
                if !model.id.isEmpty {
                    return model
                }
                return nil
            }
            
            array = result

        }
        sut.mangas = array
        return sut
    }

}
