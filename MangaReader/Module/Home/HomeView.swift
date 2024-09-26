//
//  HomeView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 30/08/24.
//

import SwiftUI
import Utilities
import FavoriteStorage
import MangaDexResponse

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        List {
            ForEach(viewModel.mangas) { manga in
                Button(action: {
                    viewModel.didSelectManga(manga)
                }, label: {
                    MangaCell(manga: manga)
                })
                .buttonStyle(PlainButtonStyle())
                
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

struct MangaCell: View {
    
    let manga: MangaModel
    
    var body: some View {
        HStack(alignment: .top) {
            if let cover = manga.cover?.coverUrl {
                CustomAsyncImage(url: cover)
                    .frame(width: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text(manga.title)
                Text("NSFW")
                    .font(.footnote)
                    .padding(3)
                    .background {
                        RoundedRectangle(cornerRadius: 2)
                            .foregroundStyle(.red)
                    }
                    .opacity(manga.contentRating == .pornographic ? 1 : 0)
            }
            
            Spacer()
            
        }
    }
}
