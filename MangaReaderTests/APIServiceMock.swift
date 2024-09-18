//
//  APIServiceMock.swift
//  MangaReaderTests
//
//  Created by Fandrian Rhamadiansyah on 04/09/24.
//

import XCTest
import MangaDexResponse
@testable import MangaReader


enum MockDataType: String {
    case listManga = "MockMangaList"
    case listChapter = "MockChapterList"
    case mangaDetail = "MockManga"
 
}

struct APIServiceMock: Requestable {
    
    var fetchMangasExpectation: XCTestExpectation?
    
    var mockType: MockDataType
    
    func apiRequest(request: URLRequest) async throws -> MangaDexResponse {
        fetchMangasExpectation?.fulfill()
//        let bundlePath = Bundle.main.path(forResource: mockType.rawValue, ofType: "json")
//        let jsonData = try String(contentsOfFile: bundlePath!).data(using: .utf8)
//        let response  = try JSONDecoder().decode(MangaDexResponse.self, from: jsonData!)
        let response = try MockData.fetchMockResponse(mockType: mockType)
        return response
    }
    
    
}

class MockData {
    static func fetchMockResponse(mockType: MockDataType) throws -> MangaDexResponse {
        let bundlePath = Bundle(for: MockData.self).path(forResource: mockType.rawValue, ofType: "json")!
        let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)!
        let response = try JSONDecoder().decode(MangaDexResponse.self, from: jsonData)
        return response
    }
    
}
