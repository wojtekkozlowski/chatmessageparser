//
//  Futures.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import Kanna

protocol URLTitleFormatter {
    func format(_ doc: HTMLDocument, urlString: String?) -> String?
    func matches(_ urlString: String) -> Bool
}

struct StringFutureToken: FutureToken {
    let text: String
    let name: String
    func promise() -> Promise<Token> {
        return Promise(value: StringToken(text: text, name: name))
    }
}

struct URLFutureToken: FutureToken {
    let text: String
    let name: String
    private let networkService = ContainerWrapper.sharedInstance.container.resolve(NetworkService.self)!
    
    func promise() -> Promise<Token> {
        return Promise<Token> { fulfill, reject in
            self.networkService.getURL(text) { (response, urlString) in
                let title = response.flatMap { value in
                    Kanna.HTML(html: value, encoding: String.Encoding.utf8).flatMap { doc in
                        URLTitleFormatterFactory.sharedInstance.formatterForURL(urlString).format(doc, urlString: urlString).map { $0 }
                    }
                }
                let urlToken = URLToken(url: self.text, title: title, name: self.name)
                fulfill(urlToken)
            }
        }
    }
}
