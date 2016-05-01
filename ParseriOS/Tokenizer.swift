//
//  Tokenizer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import UIKit
import FutureKit
import Alamofire

protocol Token {
    var name: String { get }
    func desc() -> AnyObject
}

protocol FutureToken {
    func future() -> Future<Token>
}

class Tokenizer {
    
    private var tokenDefinitions:[TokenDefinition] = []
    
    func addTokenDefinition(regexpString:String, type: TokenType){
        let regexp = try! NSRegularExpression(pattern: regexpString, options: [])
        let tokenDefinition = TokenDefinition(regexp: regexp, type: type)
        self.tokenDefinitions.append(tokenDefinition)
    }
    
    func tokensFuture(input:String) -> Future<[Token]> {
        let futureTokens = self.createFutureTokens(input)
        return self.tokensFuture(futureTokens)
    }
    
    private func createFutureTokens(input: String) -> [FutureToken] {
        return self.tokenDefinitions.map { tokenDefinition -> [FutureToken] in
            let matches = tokenDefinition.regexp.matchesInString(input, options: [], range: NSMakeRange(0, input.characters.count))
            return matches.map { match -> FutureToken in
                let tokenText = (input as NSString).substringWithRange(match.range)
                return tokenDefinition.token(tokenText)
                
            }
        }.flatMap { $0 }
    }
    
    private func tokensFuture(futureTokens:[FutureToken]) -> Future<[Token]> {
        let p = Promise<[Token]>()
        
        futureTokens.map({ (item: FutureToken, callback) in
            item.future().onSuccess(block: { callback($0) })
        }) { p.completeWithSuccess($0) }
        
        return p.future
    }
    
}
