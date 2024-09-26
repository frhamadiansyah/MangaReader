//
//  ReadChapterService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 19/09/24.
//

import Foundation
import MangaDexResponse

let baseUrl = "https://api.mangadex.org"

protocol ReadChapterServing {
    func fetchChapterPage(chapterId: String) async throws -> ReadChapterModel
}

struct ReadChapterService: ReadChapterServing {
    
    let apiService: Requestable
    
    func fetchChapterPage(chapterId: String) async throws -> ReadChapterModel {
        let urlString = "\(baseUrl)/at-home/server/\(chapterId)"

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let response = try await apiService.apiRequest(request: request)
            let result = ReadChapterModel(response)
            return result
        } else {
            throw MangaReaderError.otherError(URLError(.badURL))
        }
    }
    
}
