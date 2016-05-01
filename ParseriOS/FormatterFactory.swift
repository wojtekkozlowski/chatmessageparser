//
//  URLTitleFormatterFactory.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import Kanna

class URLTitleFormatterFactory {
    static let sharedInstance: URLTitleFormatterFactory = URLTitleFormatterFactory(
        defaultFormatter: PlainURLTitleFormatter(),
        formatters: [TwitterURLTitleFormatter()])
    
    let formatters: [URLTitleFormatter]
    let defaultFormatter: URLTitleFormatter
    
    init(defaultFormatter: URLTitleFormatter, formatters: [URLTitleFormatter]){
        self.defaultFormatter = defaultFormatter
        self.formatters = formatters
    }
    
    func formatterForURL(urlStringOrNil: String?) -> URLTitleFormatter {
        if let urlString = urlStringOrNil, let i = self.formatters.indexOf({$0.matches(urlString)}) {
            return self.formatters[i]
        } else {
            return defaultFormatter
        }
    }
}


class TwitterURLTitleFormatter: URLTitleFormatter {
    
    private let regexpString:String = "(?<=\\/www\\.|\\/)twitter\\.com"
    
    lazy var regExp: NSRegularExpression =  {
        return try! NSRegularExpression(pattern: self.regexpString, options: [])
    }()
    
    func matches(urlString: String) -> Bool {
        return self.regExp.matchesInString(urlString, options: [], range: NSMakeRange(0, urlString.characters.count)).count == 1
    }
    
    func format(doc: HTMLDocument, urlString: String?) -> String? {
        let twitterHandle = self.formatterTwitterHandle(urlString)
        let tweetText = self.formattedTweet(doc)
        return "Twitter / \(twitterHandle) \(tweetText)"
    }
    
    private func tweetText(doc: HTMLDocument) -> String? {
        return doc.xpath("//*[contains(@class, 'tweet-text')]").first?.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    private func formattedTweet(doc:HTMLDocument) -> String {
        return self.tweetText(doc) ?? ""
    }
    
    private func twitterHandle(urlString:String?) -> String? {
        return urlString.flatMap { string in
            let handleRegExp = try? NSRegularExpression(pattern: "(?<=twitter\\.com\\/)\\w*", options: [])
            return handleRegExp.flatMap { regex in
                let match = regex.firstMatchInString(string, options: [], range: NSMakeRange(0,string.characters.count))
                return match.map { (string as NSString).substringWithRange($0.range) }
            }
        }
    }
    
    private func formatterTwitterHandle(urlString:String?) -> String {
        if let handle = self.twitterHandle(urlString) {
            return "\(handle):"
        } else {
            return ""
        }
    }

}

class PlainURLTitleFormatter: URLTitleFormatter {
    
    func format(doc: HTMLDocument, urlString: String?) -> String? {
        return doc.title
    }
    
    func matches(urlString: String) -> Bool {
        return true
    }
}


