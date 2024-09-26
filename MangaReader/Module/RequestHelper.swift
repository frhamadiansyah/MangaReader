//
//  RequestHelper.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 02/09/24.
//

import Foundation
import MangaDexResponse

struct RequestHelper {
    
    private let showNSFWKey: String = "showNSFWKey"
    
    func generateBaseRequest(limit: Int = queryLimit, offset: Int = 0) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mangadex.org"
        components.path = "/manga"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
    
            // add all contentRating
//            URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.suggestive.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.erotica.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.safeContent.rawValue),
    
            // add all include
            URLQueryItem(name: "includes[]", value: "cover_art"),
            URLQueryItem(name: "includes[]", value: "author"),
            URLQueryItem(name: "includes[]", value: "artist"),
            
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en"),
            
            //excluded tags
            URLQueryItem(name: "excludedTags[]", value: "5920b825-4181-4a17-beeb-9918b0ff7a30"),
            URLQueryItem(name: "excludedTags[]", value: "2d1f5d56-a1e5-4d0d-a961-2193588b08ec"),
            
    
        ]
        if UserDefaults.standard.bool(forKey: showNSFWKey) {
            components.queryItems?.append(URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue))
        }
        return components
    }
    
    func generateListMangaRequest(mangaIds: [String], limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)
    
        for item in mangaIds {
            components.queryItems?.append(URLQueryItem(name: "ids[]", value: item))
        }
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func searchMangaRequest(title: String, limit: Int = queryLimit, offset: Int = 0) -> URLRequest {
        var components = generateBaseRequest(limit: limit, offset: offset)

        components.queryItems?.append(URLQueryItem(name: "title", value: title))
    
        let url = components.url
        return URLRequest(url: url!)
    }
    
    func generateListChaptersRequest(mangaId: String, limit: Int, offset: Int, ascending: Bool) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.mangadex.org"
        components.path = "/chapter"
        components.queryItems = [
            URLQueryItem(name: "manga", value: mangaId),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            
            // add all contentRating
//            URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.suggestive.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.erotica.rawValue),
            URLQueryItem(name: "contentRating[]", value: ContentRating.safeContent.rawValue),
            
            // add all include
            URLQueryItem(name: "includes[]", value: "scanlation_group"),
            URLQueryItem(name: "includes[]", value: "manga"),
            URLQueryItem(name: "includes[]", value: "user"),
            
            URLQueryItem(name: "translatedLanguage[]", value: "en"),
            
        ]
        
        if UserDefaults.standard.bool(forKey: showNSFWKey) {
            components.queryItems?.append(URLQueryItem(name: "contentRating[]", value: ContentRating.pornographic.rawValue))
        }
        
        if ascending {
            components.queryItems?.append(URLQueryItem(name: "order[chapter]", value: "asc"))
        } else {
            components.queryItems?.append(URLQueryItem(name: "order[chapter]", value: "desc"))
        }
        
        let url = components.url
        return URLRequest(url: url!)
    }
    
    
    
}
