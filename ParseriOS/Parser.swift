//
//  Parser.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import FutureKit

class Parser {
    private let tokenizer: Tokenizer
    private let transformer: TokenJSONTransformer
    init(tokenizer: Tokenizer, transformer: TokenJSONTransformer) {
        self.tokenizer = tokenizer
        self.transformer = transformer
    }
    
    func parse(input:String) -> Future<String> {
        let tokensFuture = self.tokenizer.tokensFuture(input)
        return tokensFuture.onSuccess { tokens -> Future<String> in
            return Future<String>(success: self.transformer.serialize(tokens))
        }
    }
}
