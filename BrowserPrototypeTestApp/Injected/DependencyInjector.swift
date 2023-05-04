//
//  DependencyInjector.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

//import SwiftUI
import Combine

struct DIContainer {
    
    let appState: Store<AppState>
    let storageServices: DIContainer.StorageService
    
    init(appState: Store<AppState>,
         storageServices: StorageService) {
        self.appState = appState
        self.storageServices = storageServices
    }
}
