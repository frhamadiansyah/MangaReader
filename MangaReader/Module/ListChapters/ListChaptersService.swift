//
//  ListChaptersService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import Foundation
import MangaDexResponse

protocol ListChaptersServing {
    func fetchChapters(mangaId: String, limit: Int, offset: Int, ascending: Bool) async throws -> [ChapterModel]
}

struct ListChaptersService: ListChaptersServing {
    
    let apiService: Requestable
    
    func fetchChapters(mangaId: String, limit: Int, offset: Int, ascending: Bool) async throws -> [ChapterModel] {
        
        let request = RequestHelper().generateListChaptersRequest(mangaId: mangaId, limit: limit, offset: offset, ascending: ascending)
        
        let response = try await apiService.apiRequest(request: request)
        
        if case .collection(let chapters) = response.data {
            let result = chapters.compactMap { chapter in
                let model = ChapterModel(chapter)
                if !model.id.isEmpty && model.externalUrl == nil {
                    return model
                }
                return nil
            }
            if result.isEmpty {
                throw MangaReaderError.noChapter
            }
            return result

        } else {
            throw MangaReaderError.backendError(MangaDexErrorStruct(
                id: UUID().uuidString,
                status: 0,
                title: "Different list manga response. Check mangadex docs for updates"
            ))
        }
    }
    
    
}
