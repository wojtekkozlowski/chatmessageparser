//
//  Tokenizer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Alamofire

protocol Token {
    var name: String { get }
    func desc() -> Any
}

protocol FutureToken {
    func promise() -> Promise<Token>
}

class Tokenizer {
    
    fileprivate var tokenDefinitions = [TokenDefinition]()
    
    func addTokenDefinition(_ regexpString:String, type: TokenType){
        let regexp = try! NSRegularExpression(pattern: regexpString, options: [])
        let tokenDefinition = TokenDefinition(regexp: regexp, type: type)
        self.tokenDefinitions.append(tokenDefinition)
    }
    
    func tokensFuture(_ input:String) -> Promise<[Token]> {
        let futureTokens = self.createFutureTokens(input)
        return when(fulfilled: futureTokens.map { $0.promise() })
    }
    
    private func createFutureTokens(_ input: String) -> [FutureToken] {
        return self.tokenDefinitions.map { tokenDefinition -> [FutureToken] in
            let matches = tokenDefinition.regexp.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
            return matches.map { match -> FutureToken in
                let tokenText = (input as NSString).substring(with: match.range)
                return tokenDefinition.token(tokenText)
                
            }
        }.flatMap { $0 }
    }
    
}
