//
//  State.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation

struct AppState: Equatable {
    var historyState: [String] = []
    var selectedUrl: String = ""
}
