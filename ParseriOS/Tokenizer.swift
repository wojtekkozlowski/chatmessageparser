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

protocol PromiseToken {
    func promise() -> Promise<[String: Any]>
}

class Tokenizer {
    
    private var tokenDefinitions = [TokenDefinition]()
    
    func addTokenDefinition(_ regexpString:String, type: TokenType){
        let regexp = try! NSRegularExpression(pattern: regexpString, options: [])
        let tokenDefinition = TokenDefinition(regexp: regexp, type: type)
        self.tokenDefinitions.append(tokenDefinition)
    }
    
    func tokensFuture(_ input:String) -> Promise<[[String: Any]]> {
        let tokenPromises = self.tokenDefinitions.map { tokenDefinition -> [Promise<[String: Any]>] in
            let matches = tokenDefinition.regexp.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
            return matches.map { match -> Promise<[String: Any]> in
                let tokenText = (input as NSString).substring(with: match.range)
                return tokenDefinition.token(tokenText).promise()
            }
            }.flatMap { $0 }
        
        return when(fulfilled: tokenPromises)
    }
    
}
