//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import Foundation

public struct ChapterModel: Identifiable {
    public let id: String
    public var chapter: Float = 0
    public var title: String = "No Title"
    public var group: String = "Unknown"
    
    public var manga: MangaModel?
    public var pages: Int?
    
    public var externalUrl: String?
    
    public init(_ response: MangaDexData) {
        id = response.id
        
        guard case .chapter(let chap) = response.attributes else {
            return
        }
        chapter = Float(chap.chapter) ?? 0
        title = chap.title ?? "no title"
        externalUrl = chap.externalUrl
        pages = chap.pages
        
        guard let relationships = response.relationships else { return }
        
        for relationship in relationships where relationship.type != .unknownType {
            if relationship.type == .manga {
                manga = MangaModel(relationship)
            } else if relationship.type == .scanlation {
                guard case .creator(let creator) = relationship.attributes else { return }
                group = creator.name
            }
        }
    }
    
    public init() {
        id = ""
    }
    
    public func chapterTitleString() -> String {
        return "\(chapter.toString()): \(title)"

    }
    
}

extension Float {
    func toString() -> String {
        if self.rounded(.up) == self.rounded(.down) {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.2f", self)
        }
    }
}
