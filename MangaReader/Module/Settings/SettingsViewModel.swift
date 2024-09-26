//
//  SettingsViewModel.swift
//  MangaReader
//
//  Created by Fandrian Rhamadiansyah on 26/09/24.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Published var showNSFW: Bool {
        didSet {
            UserDefaults.standard.setValue(showNSFW, forKey: showNSFWKey)
        }
    }
    private let showNSFWKey: String = "showNSFWKey"
    
    init() {
        showNSFW = UserDefaults.standard.bool(forKey: showNSFWKey)
    }
    
}

