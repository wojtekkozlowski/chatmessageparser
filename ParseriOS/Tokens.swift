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
    func token(_ text: String) -> FutureToken {
        switch type {
        case .stringToken(let name):
            return StringFutureToken(text: text, name: name)
        case .urlToken (let name):
            return URLFutureToken(text: text, name: name)
        }
    }
}

struct StringToken: Token {
    let text:String
    let name: String
    func desc() -> Any {
        return text as Any
    }
}

struct URLToken: Token {
    let url:String
    let title: String?
    let name: String
    
    func desc() -> Any {
        if let title = self.title {
            return ["url":url, "title":title]
        } else {
            return ["url":url]
        }
    }
}
