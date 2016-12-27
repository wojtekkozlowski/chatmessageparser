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

typealias TokenDictionary = [String: Any]

protocol PromiseToken {
    func promise() -> Promise<TokenDictionary>
}

class Tokenizer {

    private var tokenDefinitions = [TokenDefinition]()

    func addTokenDefinition(_ regexpString: String, type: TokenType) {
        let regexp = try! NSRegularExpression(pattern: regexpString, options: [])
        let tokenDefinition = TokenDefinition(regexp: regexp, type: type)
        self.tokenDefinitions.append(tokenDefinition)
    }
    
    func tokensPromise(_ input: String) -> Promise<[TokenDictionary]> {
        let tokenDictionaryPromises = self.tokenDefinitions.map { tokenDefinition -> [Promise<TokenDictionary>] in
            let matches = tokenDefinition.regexp.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
            return matches.map { match -> Promise<TokenDictionary> in
                let tokenText = (input as NSString).substring(with: match.range)
                return tokenDefinition.token(tokenText).promise()
            }
        }.flatMap { $0 }

        return when(fulfilled: tokenDictionaryPromises)
    }
    
    
    func mergeTokenDictionaries(_ tokens: [TokenDictionary]) -> TokenDictionary {
        return tokens.reduce([String: [Any]]()) { (acc, element) in
            var newAcc = acc
            let elementKey = element.keys.first!
            
            if newAcc[elementKey] == nil {
                newAcc[elementKey] = [Any]()
            }
            newAcc[elementKey]!.append(contentsOf: element.values)
            
            return newAcc
        }
    }
}
