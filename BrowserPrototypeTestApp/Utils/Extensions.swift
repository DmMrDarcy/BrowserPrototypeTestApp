//
//  Extensions.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Foundation

extension Data {
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(T.self, from: self)
    }
}
