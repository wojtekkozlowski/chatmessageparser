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

enum TokenType {
    case stringToken(String)
    case urlToken(String)
}

struct TokenDefinition {
    let regexp: NSRegularExpression
    let type: TokenType
    func token(_ text: String) -> PromiseToken {
        switch type {
        case .stringToken(let name):
            return StringPromiseToken(text: text, name: name)
        case .urlToken(let name):
            return URLPromiseToken(text: text, name: name)
        }
    }
}

protocol URLTitleFormatter {
    func format(_ doc: HTMLDocument, urlString: String?) -> String?
    func matches(_ urlString: String) -> Bool
}

struct StringPromiseToken: PromiseToken {
    let text: String
    let name: String

    func promise() -> Promise<[String: Any]> {
        return Promise(value: self.toDictionary())
    }

    private func toDictionary() -> [String: Any] {
        return [self.name: text]
    }
}

struct URLPromiseToken: PromiseToken {
    let text: String
    let name: String
    private let networkService = ContainerWrapper.sharedInstance.container.resolve(NetworkService.self)!

    func promise() -> Promise<[String: Any]> {
        return Promise<[String: Any]> { fulfill, reject in
            self.networkService.getURL(text) { (response, urlString) in
                let title = response.flatMap { value in
                    Kanna.HTML(html: value, encoding: String.Encoding.utf8).flatMap { doc in
                        URLTitleFormatterFactory.sharedInstance.formatterForURL(urlString).format(doc, urlString: urlString).map { $0 }
                    }
                }
                fulfill(self.toDictionary(url: self.text, title: title))
            }
        }
    }

    private func toDictionary(url: String, title: String?) -> [String: Any] {
        if let title = title {
            return ["url": url, "title": title]
        } else {
            return ["url": url]
        }
    }
}
