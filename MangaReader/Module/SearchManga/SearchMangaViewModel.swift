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
    @Published var homeError: MangaReaderError?
    @Published var showError: Bool = false
    
    @Published var searchText: String = ""

    private let service: SearchMangaServing
    private let onMangaSelected: (MangaModel) -> Void

    init(service: SearchMangaServing, onMangaSelected: @escaping (MangaModel) -> Void) {
        self.service = service
        self.onMangaSelected = onMangaSelected
    }
    
    func searchManga() {
        mangas = []
        
        if !searchText.isEmpty {
            let limit = 50
            let offset = 0
            Task { @MainActor in
                do {
                    mangas = try await service.searchMangaByTitle(title: searchText, limit: limit, offset: offset)
                    
                } catch {
                    if let err = error as? MangaReaderError {
                        homeError = err
                        showError.toggle()
                    }
                }
            }
        }
    }

    func didSelectManga(_ manga: MangaModel) {
        onMangaSelected(manga)
    }
}
