//
//  ListChaptersView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 18/09/24.
//

import SwiftUI
import MangaDexResponse

struct ListChaptersView: View {
    
    @ObservedObject var viewModel: ListChaptersViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .opacity(0)
                Spacer()
                Text(viewModel.manga.title)
                Spacer()
                Button(action: {
                    viewModel.ascending.toggle()
                    viewModel.reloadChapters()
                }, label: {
                    if viewModel.ascending {
                        Image(systemName: "arrow.up.arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.blue, .red)
                    } else {
                        Image(systemName: "arrow.up.arrow.down")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.red, .blue)
                    }
                    
                })
                
            }
            .padding()
            
            List {
                ForEach(viewModel.chapters) { chapter in
                    Button(action: {
                        viewModel.openChapter(chapter)
                    }, label: {
                        Text("\(chapter.chapterTitleString())")
                    })
                        .onAppear {
                            viewModel.loadMoreIfNeeded(chapterId: chapter.id)
                        }
                }
                if viewModel.isLoading {
                    ProgressView()
                }

            }
            .refreshable {
                viewModel.reloadChapters()
            }
            .onAppear {
                viewModel.reloadChapters()
            }
            
        }
    }
}


#Preview {
    ListChaptersView(viewModel: ListChaptersViewModel(manga: MangaModel(), service: ListChaptersService(apiService: MockAPIService()), onChapterSelected: {_ in}))
}
