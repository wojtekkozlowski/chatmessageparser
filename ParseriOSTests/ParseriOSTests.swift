//
//  ParseriOSTests.swift
//  ParseriOSTests
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import XCTest
import Nimble
import PromiseKit
@testable import ParseriOS

class ParseriOSTests: XCTestCase {
    
    func testFutures(){
        let tokenizer = ContainerWrapper.sharedInstance.container.resolve(Tokenizer.self)!
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

