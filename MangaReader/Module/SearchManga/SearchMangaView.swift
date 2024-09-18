//
//  SearchMangaView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 13/09/24.
//

import SwiftUI
import Utilities

struct SearchMangaView: View {
    
    @ObservedObject var viewModel: SearchMangaViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search Manga", text: $viewModel.searchText)
                Button(action: {
                    viewModel.newQueryMangaSearch()
                }, label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundStyle(.gray)
                        }
                })
            }
            .padding(.horizontal)
            List {
                ForEach(viewModel.mangas) { manga in
                    Text(manga.title)
                        .onTapGesture {
                            viewModel.didSelectManga(manga)
                        }
                        .onAppear {
                            viewModel.loadMoreIfNeeded(mangaId: manga.id)
                        }
                }
                if viewModel.isLoading {
                    ProgressView()
                }

            }
            .refreshable {
                viewModel.newQueryMangaSearch()
            }
        }
        .padding(.horizontal)
        .handleError(error: viewModel.homeError, showError: $viewModel.showError, completion: {})
    }
}
