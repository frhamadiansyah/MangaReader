//
//  APIService.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import Foundation
import MangaDexResponse

protocol Requestable {
    func apiRequest(request: URLRequest) async throws -> MangaDexResponse
}

let queryLimit = 50
struct APIService: Requestable {
    
    
    func apiRequest(request: URLRequest) async throws -> MangaDexResponse {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let result = try JSONDecoder().decode(MangaDexResponse.self, from: data)
        return result
    }

}

struct MockAPIService: Requestable {
    func apiRequest(request: URLRequest) async throws -> MangaDexResponse {
        return MangaDexResponse()
    }

}

