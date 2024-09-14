//
//  SearchService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import Foundation
import MangaDexResponse

protocol SearchMangaServing {
    func searchMangaByTitle(title: String, limit: Int, offset: Int) async throws -> [MangaModel]
}

struct SearchMangaService: SearchMangaServing {
    
    let apiService: Requestable
    
    func searchMangaByTitle(title: String, limit: Int, offset: Int) async throws -> [MangaModel] {
        
        let components = RequestHelper().searchMangaRequest(title: title, limit: limit, offset: offset)
    
    
        if let url = components.url {
            let request = URLRequest(url: url)
            let response = try await apiService.apiRequest(request: request)
            if case .collection(let mangas) = response.data {
                let result = mangas.compactMap { manga in
                    let model = MangaModel(manga)
                    if !model.id.isEmpty {
                        return model
                    }
                    return nil
                }
                if result.isEmpty {
                    throw MangaReaderError.noMangaFound
                }
                return result

            } else {
                throw MangaReaderError.backendError(MangaDexErrorStruct(
                    id: UUID().uuidString,
                    status: 0,
                    title: "Different list manga response. Check mangadex docs for updates"
                ))
            }
        } else {
            throw MangaReaderError.otherError(URLError(.badURL))
        }
    }
    
    
}
