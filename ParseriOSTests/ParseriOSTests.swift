//
//  ParseriOSTests.swift
//  ParseriOSTests
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import XCTest
import Nimble
import FutureKit
@testable import ParseriOS

class ParseriOSTests: XCTestCase {
    
    private var tokenizer: Tokenizer!
    
    override func setUp() {
        super.setUp()
        self.tokenizer = Tokenizer()
        tokenizer.addTokenDefinition("(?<=@)(\\w|\\d){1,}", type: .StringToken("mentions"))
        tokenizer.addTokenDefinition("(?<=\\()\\w{1,15}(?=\\))", type: .StringToken("emoticons"))
        tokenizer.addTokenDefinition("((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)", type:.URLToken("links"))
    }
    
    func testFutures(){
        let tokensFuture = tokenizer.tokensFuture("@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016")

        var mentions: [String]?
        var emoticons: [String]?
        var links: [[String:String]]?
        
        tokensFuture.onSuccess { tokens  in
            let tokensDict = TokenJSONTransformer().transformTokensToDictionary(tokens)
            mentions = tokensDict["mentions"] as? [String]
            emoticons = tokensDict["emoticons"] as? [String]
            links = tokensDict["links"] as? [[String:String]]
        }
        
        expect(mentions).toEventually(equal(["bob", "john"]))
        expect(emoticons).toEventually(equal(["success"]))
        expect(links).toEventually(equal([["title": "Twitter / jdorfman: Sweet","url":"https://twitter.com/jdorfman/status/430511497475670016"]]))
    }
}

