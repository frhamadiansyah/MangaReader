//
//  MockHomeService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 04/09/24.
//

import Foundation
import MangaDexResponse

struct HomeServiceMock: HomeServing {
    
    func fetchFavoriteManga(favoriteMangaIds: [String], limit: Int, offset: Int) async throws -> [MangaModel] {
        return [
            MangaModel()
        ]
    }
    
    
}
