//
//  Parser.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import PromiseKit

class Parser {
    fileprivate let tokenizer: Tokenizer
    fileprivate let transformer: TokenJSONTransformer
    
    init(tokenizer: Tokenizer, transformer: TokenJSONTransformer) {
        self.tokenizer = tokenizer
        self.transformer = transformer
    }
    
    func parse(_ input:String) -> Promise<String> {
        let tokensPromise = self.tokenizer.tokensFuture(input)
        return  tokensPromise.then { tokens in
            return Promise(value: tokens)
        }.then { tokens in
            return self.transformer.serialize(tokens)
        }
        //return a.then { tokens in
        //    return self.transformer.serialize(tokens)
        //}
    }
}
