//
//  Tokens.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

enum TokenType {
    case stringToken (String)
    case urlToken (String)
}

struct TokenDefinition {
    let regexp: NSRegularExpression
    let type: TokenType
    func token(_ text: String) -> PromiseToken {
        switch type {
        case .stringToken(let name):
            return StringPromiseToken(text: text, name: name)
        case .urlToken (let name):
            return URLPromiseToken(text: text, name: name)
        }
    }
}


