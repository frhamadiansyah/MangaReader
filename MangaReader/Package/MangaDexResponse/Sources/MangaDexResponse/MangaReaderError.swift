//
//  File.swift
//  
//
//  Created by Fandrian Rhamadiansyah on 02/09/24.
//

import Foundation

public enum MangaReaderError: Error {
    case networkError(Error)
    case backendError(MangaDexErrorStruct)
    case otherError(Error)
    case noChapter
    case noMangaFound
    case differentResponse
}
