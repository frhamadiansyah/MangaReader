//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 19/09/24.
//

import Foundation

public struct ReadChapterModel {
    public let baseUrl: String
    public var hash: String = ""
    public var fileName: [String] = []
    public var imageUrls: [String] = []
    public var saverFileName: [String] = []
    public var saverImageUrls: [String] = []
    
    public init(_ response: MangaDexResponse) {
        baseUrl = response.baseUrl ?? ""
        guard let chapter = response.chapter else { return }
        
        hash = chapter.hash
        fileName.append(contentsOf: chapter.data)
        imageUrls = fileName.map({ name in
            return "\(baseUrl)/data/\(hash)/\(name)"
        })
        saverFileName.append(contentsOf: chapter.dataSaver)
        saverImageUrls = saverFileName.map({ name in
            return "\(baseUrl)/data-saver/\(hash)/\(name)"
        })
    }
}
