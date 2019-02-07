//
//  StringExtension.swift
//  IMC
//
//  Created by Mohamed Salah Zidane on 2/5/19.
//  Copyright © 2019 Mohamed Salah Zidane. All rights reserved.
//

import Foundation
extension String {
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && (range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil) ||  !isEmpty && range(of: "[^أ-أي-٠ي-٩]", options: .regularExpression) == nil
    }
    
}
