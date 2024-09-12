//
//  HomeService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 03/09/24.
//

import Foundation
import MangaDexResponse

protocol HomeServing {
    func fetchFavoriteManga(favoriteMangaIds: [String], limit: Int, offset: Int) async throws -> [MangaModel]
}

struct HomeService: HomeServing {
    
    let apiService: Requestable
    
    func fetchFavoriteManga(favoriteMangaIds: [String], limit: Int, offset: Int) async throws -> [MangaModel] {
        
        var components = RequestHelper().generateBaseRequest(limit: limit, offset: offset)
    
        for item in favoriteMangaIds {
            components.queryItems?.append(URLQueryItem(name: "ids[]", value: item))
        }
    
        if let url = components.url {
            let request = URLRequest(url: url)
            let response = try await apiService.apiRequest(request: request)
            if case .collection(let mangas) = response.data {
                let result = mangas.map { MangaModel($0) }
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
