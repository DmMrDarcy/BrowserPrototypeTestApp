//
//  RegExp.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 03.05.2023.
//

import Foundation

let urlRegex = #"^(https?://)?([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}(:[0-9]{1,5})?(/[^\s]*)?$"#

func isValidUrl(urlString: String) -> Bool {
    let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegex)
    return urlTest.evaluate(with: urlString.lowercased())
}
