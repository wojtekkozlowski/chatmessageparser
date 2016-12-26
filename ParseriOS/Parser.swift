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
    private let tokenizer: Tokenizer
    private let transformer: TokenJSONTransformer
    
    init(tokenizer: Tokenizer, transformer: TokenJSONTransformer) {
        self.tokenizer = tokenizer
        self.transformer = transformer
    }
    
    func parse(_ input:String) -> Promise<String> {
        return self.tokenizer.tokensFuture(input).then { tokens in
            return self.transformer.serialize(tokens)
        }
    }
}
