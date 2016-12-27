//
//  ParseriOSTests.swift
//  ParseriOSTests
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import XCTest
import PromiseKit
import Swinject
import Nimble
@testable import ParseriOS

class ParseriOSTests: XCTestCase {
    
    func testFutures() {
        AppDelegate.self.container.register(NetworkService.self) { _ in
            let response = (urlString: "https://twitter.com/jdorfman/status/430511497475670016",
                            responseString: "<html><body><div class=\"tweet-text\">Sweet</div>")
            return StubNetworkingService(responseTuples: [response])
        }
        let tokenizer = AppDelegate.self.container.resolve(Tokenizer.self)!
        let tokensFuture = tokenizer.tokensPromise("@bob (awesome) @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016 https://example.com/")
        
        var mentions: [String]!
        var emoticons: [String]!
        var links: [[String: String]]!
        
        _ = tokensFuture.then { tokens -> Void in
            let tokensDict = TokenJSONTransformer().mergeTokens(tokens)
            mentions = tokensDict["mentions"] as? [String]
            emoticons = tokensDict["emoticons"] as? [String]
            links = tokensDict["links"] as? [[String: String]]
            print(tokensDict.serialize())
        }
        
        expect(mentions).toEventually(equal(["bob", "john"]))
        expect(emoticons).toEventually(equal(["awesome", "success"]))
        expect(links.count).to(equal(2))
        expect(links[0]).toEventually(equal(["title": "Twitter / jdorfman: Sweet", "url": "https://twitter.com/jdorfman/status/430511497475670016"]))
        expect(links[1]).toEventually(equal(["url": "https://example.com/"]))
    }
}

class StubNetworkingService: NetworkService {
    private let responseTuples: [(urlString: String, responseString: String)]
    
    init(responseTuples: [(urlString: String, responseString: String)]){
       self.responseTuples = responseTuples
    }
    
    func getURL(_ urlString: String, completion: @escaping (_ response: String?, _ urlString: String?) -> Void) {
        if let responseTuple = self.responseTuples.filter({ $0.urlString == urlString }).first {
            completion(responseTuple.responseString, responseTuple.urlString)
        } else {
            completion("","wrong url")
        }
    }
}

