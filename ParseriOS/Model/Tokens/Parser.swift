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

    init(tokenizer: Tokenizer) {
        self.tokenizer = tokenizer
    }

    func parse(_ input: String) -> Promise<String> {
        return self.tokenizer.tokensPromise(input).then { tokenDictionaries in
            return self.tokenizer.mergeTokenDictionaries(tokenDictionaries).serialize()
        }
    }
}
