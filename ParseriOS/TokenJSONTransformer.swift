//
//  TokenJSONTransformer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 29/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

class TokenJSONTransformer {
    
    func serialize(_ tokens: [Token]) -> String {
        let dictionary = self.transformTokensToDictionary(tokens)
        return self.serializeDictioanry(dictionary)
    }
    
    func transformTokensToDictionary(_ tokens: [Token]) -> [String:[AnyObject]] {
        return tokens.reduce([String:[AnyObject]]()) { (aggregate, element) in
            var newAggregate = aggregate
            if newAggregate[element.name] == nil {
                newAggregate[element.name] = Array<AnyObject>()
            }
            newAggregate[element.name]!.append(element.desc() as AnyObject)
            return newAggregate
        }
    }
    
    fileprivate func serializeDictioanry(_ object: [String:[AnyObject]]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: object, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let serialized =  NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return serialized.replacingOccurrences(of: "\\/", with: "/")
    }
    
    
}
