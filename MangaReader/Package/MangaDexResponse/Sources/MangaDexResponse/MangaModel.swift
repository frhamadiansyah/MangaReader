//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 02/09/24.
//

import Foundation

let imageBaseUrl = "https://uploads.mangadex.org"

public struct MangaModel: Identifiable {
    public var id: String = ""
    public var title: String = ""
    public var description: String = ""
    public var artist: CreatorModel? = nil
    public var author: CreatorModel? = nil
    public var cover: CoverModel? = nil
    public var status: MangaStatus = .unknown
    public var contentRating: ContentRating = .unknown
    public var publicationDemographic: PublicationDemographic = .unknown
    public var tags: [String] = []
    
    public init(_ response: MangaDexData) {
        guard case .manga = response.type else {
            return
        }
        
        id = response.id
        
        guard case .manga(let manga) = response.attributes else {
            return
        }
        title = manga.title.en ?? "No Title"
        description = manga.description.en ?? "No Description"
        status = manga.status
        contentRating = manga.contentRating
        publicationDemographic = manga.publicationDemographic
        let newTags: [String?] = manga.tags.map({ data -> String? in
            guard case .tag(let tag) = data.attributes else {return nil}
            if let res = tag.name.en {
                return res
            } else {
                return nil
            }
        })
        
        tags = newTags.compactMap({$0})
        
        guard let relationships = response.relationships else { return }
        
        for relationship in relationships where relationship.type != .unknownType {
            if relationship.type == .artist {
                artist = CreatorModel(relationship)
            } else if relationship.type == .author {
                author = CreatorModel(relationship)
            } else if relationship.type == .cover {
                cover = CoverModel(relationship)
                cover?.updateCoverUrl(mangaId: id)
            }
            
            
        }

    }
    
    public init(_ response: ChildMangaDexData) {
        guard case .manga = response.type else {
            return
        }
        
        id = response.id
        
        guard case .manga(let manga) = response.attributes else {
            return
        }
        title = manga.title.en ?? "No Title"
        description = manga.description.en ?? "No Description"
        status = manga.status
        contentRating = manga.contentRating
        publicationDemographic = manga.publicationDemographic
        let newTags: [String?] = manga.tags.map({ data -> String? in
            guard case .tag(let tag) = data.attributes else {return nil}
            if let res = tag.name.en {
                return res
            } else {
                return nil
            }
        })
        
        tags = newTags.compactMap({$0})

    }
    
    public init(id: String = "", title: String = "", description: String = "") {
        self.id = id
        self.title = title
        self.description = description
    }

}

public struct CoverModel: Identifiable {
    public let id: String
    public var fileName: String = ""
    public var coverUrl: String = ""
    
    public init(_ response: ChildMangaDexData) {
        id = response.id
        
        guard case .cover(let cover) = response.attributes else {
            return
        }
        fileName = cover.fileName
        coverUrl = "\(imageBaseUrl)/covers/\(id)/\(fileName)"
    }
    
    mutating func updateCoverUrl(mangaId: String) {
        coverUrl = "\(imageBaseUrl)/covers/\(mangaId)/\(fileName).256.jpg"
    }
}

public struct CreatorModel: Identifiable {
    public let id: String
    public var name: String = "Unnamed"
    
    public init(_ response: ChildMangaDexData) {
        id = response.id
        
        guard case .creator(let creator) = response.attributes else { return }
        
        name = creator.name
    }
}
