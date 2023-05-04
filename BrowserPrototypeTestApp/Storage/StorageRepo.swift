//
//  StorageRepo.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation
import SwiftUI

fileprivate enum ConstantsLocal {
    static let historyArray = "historyArray"
}

protocol StorageRepoProtocol {
    var historyArray: [String] {get set}
}

class StorageRepo: StorageRepoProtocol {
    var historyArray: [String] {
        get {
            return historyArr.decode([String].self) ?? []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                historyArr = encoded
            }
        }
    }
    
    @AppStorage(ConstantsLocal.historyArray) var historyArr: Data = Data()
}
