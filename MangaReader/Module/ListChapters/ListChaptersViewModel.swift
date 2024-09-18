//
//  ListChaptersViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import SwiftUI
import MangaDexResponse

final class ListChaptersViewModel: ObservableObject {
    @Published var chapters = [ChapterModel]()
    @Published var isLoading = false
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false
    
    @Published var ascending: Bool = true

    private let service: ListChaptersServing
    private let onChapterSelected: (ChapterModel) -> Void
    
    private var limit: Int = 10
    private var offset: Int = 0
    
    let manga: MangaModel
    
    init(manga: MangaModel, service: ListChaptersServing, onChapterSelected: @escaping (ChapterModel) -> Void) {
        self.manga = manga
        self.service = service
        self.onChapterSelected = onChapterSelected
    }
    
    func reloadChapters() {
        chapters = []
        limit = 50
        offset = 0
        fetchChapters(ascending: ascending)
    }
    
    func fetchChapters(ascending: Bool = true) {
        guard isLoading == false else { return }
        Task { @MainActor in
            isLoading = true
            do {
                
                let result = try await service.fetchChapters(mangaId: manga.id, limit: limit, offset: offset, ascending: ascending)
                chapters.append(contentsOf: result)
                
            } catch {
                if let err = error as? MangaReaderError {
                    homeError = err
                    showError.toggle()
                }
            }
            isLoading = false
        }
    }
    
    func loadMoreIfNeeded(chapterId: String?) {
        guard let chapterId = chapterId else {
            reloadChapters()
            return
        }
        let thresholdIndex = chapters.index(chapters.endIndex, offsetBy: -5)
        if chapters.firstIndex(where: { $0.id == chapterId }) == thresholdIndex {
            loadMoreChapter()
        }
    }
    
    func loadMoreChapter() {
        offset += limit
        fetchChapters(ascending: ascending)
    }
}

