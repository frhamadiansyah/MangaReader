//
//  SearchMangaViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import SwiftUI
import MangaDexResponse

final class SearchMangaViewModel: ObservableObject {
    
    @Published var mangas = [MangaModel]()
    @Published var isLoading = false
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false
    
    @Published var searchText: String = ""

    private let service: SearchMangaServing
    private let onMangaSelected: (MangaModel) -> Void
    
    private var limit: Int = 10
    private var offset: Int = 0

    init(service: SearchMangaServing, onMangaSelected: @escaping (MangaModel) -> Void) {
        self.service = service
        self.onMangaSelected = onMangaSelected
    }
    
    func newQueryMangaSearch() {
        mangas = []
        guard isLoading == false else { return }
        if !searchText.isEmpty {
            limit = 50
            offset = 0
            Task { @MainActor in
                isLoading = true
                do {
                    mangas = try await service.searchMangaByTitle(title: searchText, limit: limit, offset: offset)
                    
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
    
    func loadMoreIfNeeded(mangaId: String?) {
        guard let mangaId = mangaId else {
            newQueryMangaSearch()
            return
        }
        let thresholdIndex = mangas.index(mangas.endIndex, offsetBy: -5)
        if mangas.firstIndex(where: { $0.id == mangaId }) == thresholdIndex {
            loadMoreManga()
        }
    }
    
    func loadMoreManga() {
        guard isLoading == false else { return }
        offset += limit
        Task { @MainActor in
            isLoading = true
            do {
                let addition = try await service.searchMangaByTitle(title: searchText, limit: limit, offset: offset)
                mangas.append(contentsOf: addition)
                
            } catch {
                if let err = error as? MangaReaderError {
                    homeError = err
                    showError.toggle()
                }
            }
            isLoading = false
        }
    }

    func didSelectManga(_ manga: MangaModel) {
        onMangaSelected(manga)
    }
}
