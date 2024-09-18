//
//  MangaDetailView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 31/08/24.
//

import Foundation
import SwiftUI

struct MangaDetailView: View {
    
    @ObservedObject var viewModel: MangaDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.manga.title)
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                if let url = viewModel.manga.cover?.coverUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                        .frame(width: 200, height: 300)
                        .cornerRadius(5)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.favoriteButtonPressedUpdateValue()
                    }, label: {
                        Image(systemName: viewModel.isFavoriteManga ? "star.fill" : "star")
                    })
                }
                .padding()
                
                Text(viewModel.manga.description)
                    .font(.body)
                
                Button(action: {
                    viewModel.openChapters()
                }, label: {
                    Text("Open Chapters")
                })
                
            }
            .padding(.horizontal)
            .onAppear(perform: {
                viewModel.fetchIsFavoriteValue()
            })

        }
    }
}
