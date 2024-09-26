//
//  SettingsView.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 26/09/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        List {
            Toggle(isOn: $viewModel.showNSFW, label: {
                Text("Show NSFW Content")
            })
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
