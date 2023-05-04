//
//  StorageService.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation

extension DIContainer {
    class StorageService {
        private let appState: Store<AppState>
        private var repo: StorageRepoProtocol
        private var cancelBag = CancelBag()
        
        init(appState: Store<AppState>, repo: StorageRepoProtocol) {
            self.appState = appState
            self.repo = repo
            
            appState[\.historyState] = repo.historyArray
            
            appState.map(\.historyState)
                .removeDuplicates()
                .dropFirst()
                .sink { [unowned self] in
                    self.repo.historyArray = $0
                }
                .store(in: cancelBag)
        }
    }
}
