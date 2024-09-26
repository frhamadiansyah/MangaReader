//
//  SearchMangaView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import SwiftUI
import Utilities
import Combine

struct SearchMangaView: View {
    
    @ObservedObject var viewModel: SearchMangaViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.mangas) { manga in
                Button(action: {
                    viewModel.didSelectManga(manga)
                }, label: {
                    MangaCell(manga: manga)
                })
                .buttonStyle(PlainButtonStyle())
                .onAppear {
                    viewModel.loadMoreIfNeeded(mangaId: manga.id)
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }

        }
        .searchable(text: $viewModel.searchText)
        .onReceive(viewModel.$searchText.debounce(for: .seconds(2), scheduler: DispatchQueue.main), perform: { _ in
            viewModel.newQueryMangaSearch()
        })
        .refreshable {
            viewModel.newQueryMangaSearch()
        }
        .handleError(error: viewModel.homeError, showError: $viewModel.showError, completion: {})
    }
}
