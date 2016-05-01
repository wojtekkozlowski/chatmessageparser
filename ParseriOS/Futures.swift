//
//  Futures.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import FutureKit
import Alamofire
import Kanna

protocol URLTitleFormatter {
    func format(doc: HTMLDocument, urlString: String?) -> String?
    func matches(urlString: String) -> Bool
}

struct StringFutureToken: FutureToken {
    let text: String
    let name: String
    func future() -> Future<Token> {
        let p = Promise<Token>()
        p.completeWithSuccess(StringToken(text: text, name: name))
        return p.future
    }
}

struct URLFutureToken: FutureToken {
    let text: String
    let name: String
    private let networkService = ContainerWrapper.sharedInstance.container.resolve(NetworkService.self)!
    
    func future() -> Future<Token> {
        let p = Promise<Token>()
        self.networkService.getURL(text) { (response, urlString) in
            let title = response.flatMap { value in
                Kanna.HTML(html: value, encoding: NSUTF8StringEncoding).flatMap { doc in
                    URLTitleFormatterFactory.sharedInstance.formatterForURL(urlString).format(doc, urlString: urlString).map { $0 }
                }
            }
            let urlToken = URLToken(url: self.text, title: title, name: self.name)
            p.completeWithSuccess(urlToken)
        }
        return p.future
    }
}
