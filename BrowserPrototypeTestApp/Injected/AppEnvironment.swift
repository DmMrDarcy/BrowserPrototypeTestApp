//
//  AppEnvironment.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation
import Combine

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store(AppState())
        
        let storageRepo = StorageRepo()
        let storageService = DIContainer.StorageService(appState: appState, repo: storageRepo)
        let diContainer = DIContainer(appState: appState, storageServices: storageService)

        return AppEnvironment(container: diContainer)
    }
}
