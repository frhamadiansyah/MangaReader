//
//  HomeView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import SwiftUI
import Utilities
import FavoriteStorage

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        List {
            ForEach(viewModel.mangas) { manga in
                Text(manga.title)
                    .onTapGesture {
                        viewModel.didSelectManga(manga)
                    }
                    .swipeActions {
                        Button(action: {
                            viewModel.removeFavoriteManga(manga: manga)
                        }, label: {
                            Text("Remove Favorite")
                        })
                        .tint(.red)
                    }
            }
            
        }
        .refreshable {
            viewModel.onAppear()
        }
        
        .onAppear {
            viewModel.onAppear()
        }
        .handleError(error: viewModel.homeError, showError: $viewModel.showError, completion: {})
        
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(homeService: HomeServiceMock(), favoriteManager: FavoriteDataManagerMock(), onMangaSelected: { _ in }))
}
