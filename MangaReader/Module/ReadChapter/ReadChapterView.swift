//
//  ReadChapterView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 19/09/24.
//

import SwiftUI
import Utilities

struct ReadChapterView: View {
    @ObservedObject var viewModel: ReadChapterViewModel
    let width = UIScreen.main.bounds.width
    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { value in
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.imageUrl, id:\.self) { string in
//                        CachedAsyncImage(url: URL(string: string))
                        CustomAsyncImage(url: string)
//                        AsyncImage(url: URL(string: string)) { image in
//                            image
//                                .resizable()
//                                .scaledToFill()
//                        } placeholder: {
//                            ProgressView()
//                        }
                            .frame(width: width)
                    }
                }
            }
        }
        .onAppear(perform: {
            viewModel.loadChapterImage()
        })
        .handleError(error: viewModel.homeError, showError: $viewModel.showError) { }
    }
}

//#Preview {
//    ReadChapterView()
//}
