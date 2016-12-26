//
//  TokenJSONTransformer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 29/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

class TokenJSONTransformer {
    
    func serialize(_ tokens: [[String: Any]]) -> String {
        let dictionary = self.transformTokensToDictionary(tokens)
        return self.serializeDictioanry(dictionary)
    }
    
    func transformTokensToDictionary(_ tokens: [[String: Any]]) -> [String:Any] {
        return tokens.reduce([String:[Any]]()) { (acc, element) in
            var newAcc = acc
            if newAcc[element.keys.first!] == nil {
                newAcc[element.keys.first!] = [Any]()
            }
            newAcc[element.keys.first!]!.append(contentsOf: element.values)
            
            return newAcc
        }
    }
    
    fileprivate func serializeDictioanry(_ object: [String:Any]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let serialized =  NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return serialized.replacingOccurrences(of: "\\/", with: "/")
    }
    
    
}
