//
//  ReadChapterViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 19/09/24.
//

import SwiftUI
import MangaDexResponse


final class ReadChapterViewModel: ObservableObject {
    
    var chapters: ReadChapterModel?
    @Published var imageUrl: [String] = []
    @Published var isLoading = false
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false
    
    private let service: ReadChapterServing
    let chapter: ChapterModel
    
    init(chapter: ChapterModel, service: ReadChapterService) {
        self.chapter = chapter
        self.service = service
    }
    
    
    func loadChapterImage() {
        Task { @MainActor in
            isLoading = true
            do {
                let chapter = try await service.fetchChapterPage(chapterId: chapter.id)
                imageUrl = chapter.saverImageUrls
            } catch {
                if let err = error as? MangaReaderError {
                    homeError = err
                    showError.toggle()
                }
            }
            isLoading = false
        }
    }
    
    
}
