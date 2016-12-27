//
//  TokenJSONTransformer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 29/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

class TokenJSONTransformer {

    func serialize(_ tokens: [TokenDictionary]) -> String {
        let dictionary = self.mergeTokens(tokens)
        return self.serialize(dictionary)
    }

    func mergeTokens(_ tokens: [TokenDictionary]) -> TokenDictionary {
        return tokens.reduce([String: [Any]]()) { (acc, element) in
            var newAcc = acc
            let elementKey = element.keys.first!
            
            if newAcc[elementKey] == nil {
                newAcc[elementKey] = [Any]()
            }
            newAcc[elementKey]!.append(contentsOf: element.values)

            return newAcc
        }
    }

    private func serialize(_ object: TokenDictionary) -> String {
        let data = try! JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let serialized = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return serialized.replacingOccurrences(of: "\\/", with: "/")
    }
}

extension Dictionary {
    func serialize() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let serialized = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return serialized.replacingOccurrences(of: "\\/", with: "/")
    }
}
