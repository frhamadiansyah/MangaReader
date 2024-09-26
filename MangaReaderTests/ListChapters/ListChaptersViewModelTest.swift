//
//  ListChaptersViewModelTest.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import XCTest
import MangaDexResponse
@testable import MangaReader

final class ListChaptersViewModelTest: XCTestCase {

    func test_fetch_chapters() async {
        let expectation = expectation(description: "fetch_favorites")

        let sut = makeSUT(mockType: .listChapter, expectation: expectation) { _ in
            
        }
        
        sut.reloadChapters()
        
        await fulfillment(of: [expectation])
        let testId = sut.chapters.first?.id
        
        XCTAssert(sut.chapters.count == 10, "got count \(sut.chapters.count)")
        XCTAssert(testId == "5dce526a-e499-4f47-acb6-22f37d554759", "testId is wrong, I got \(testId)")
    }
    
    func test_load_more_chapters() async {
        
        let expectation = expectation(description: "fetch_favorites")

        let sut = makePrefilledSUT(mockType: .listChapter, expectation: expectation) { _ in
            
        }
        let chapterId = "c692fda9-2d34-4bec-9082-b00140605a4e"
        sut.loadMoreIfNeeded(chapterId: chapterId)
        
        await fulfillment(of: [expectation])
        
        XCTAssert(sut.chapters.count == 20, "got count \(sut.chapters.count)")
    }
    
    private func makeSUT(mockType: MockDataType, expectation: XCTestExpectation?, onChapterSelected: @escaping (ChapterModel) -> Void) -> ListChaptersViewModel {
        
        var service = APIServiceMock(mockType: mockType)
        service.fetchMangasExpectation = expectation
        let listChaptersService = ListChaptersService(apiService: service)
        let sut = ListChaptersViewModel(manga: MangaModel(), service: listChaptersService, onChapterSelected: onChapterSelected)
        return sut
    }
    
    private func makePrefilledSUT(mockType: MockDataType, expectation: XCTestExpectation?, onChapterSelected: @escaping (ChapterModel) -> Void) -> ListChaptersViewModel {
        
        var service = APIServiceMock(mockType: mockType)
        service.fetchMangasExpectation = expectation
        let listChaptersService = ListChaptersService(apiService: service)
        let sut = ListChaptersViewModel(manga: MangaModel(), service: listChaptersService, onChapterSelected: onChapterSelected)
        let response = try? MockData.fetchMockResponse(mockType: mockType)
        var array = [ChapterModel]()
        if case .collection(let chapters) = response?.data {
            let result = chapters.compactMap { manga in
                let model = ChapterModel(manga)
                if !model.id.isEmpty && model.externalUrl == nil {
                    return model
                }
                return nil
            }
            
            array = result

        }
        sut.chapters = array
        return sut
    }

}
