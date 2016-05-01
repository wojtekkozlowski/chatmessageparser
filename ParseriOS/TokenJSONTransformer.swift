//
//  TokenJSONTransformer.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 29/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

class TokenJSONTransformer {
    
    func serialize(tokens: [Token]) -> String {
        let dictionary = self.transformTokensToDictionary(tokens)
        return self.serializeDictioanry(dictionary)
    }
    
    func transformTokensToDictionary(tokens: [Token]) -> [String:[AnyObject]] {
        return tokens.reduce([String:[AnyObject]]()) { (aggregate, element) in
            var newAggregate = aggregate
            if newAggregate[element.name] == nil {
                newAggregate[element.name] = Array<AnyObject>()
            }
            newAggregate[element.name]!.append(element.desc())
            return newAggregate
        }
    }
    
    private func serializeDictioanry(object: [String:[AnyObject]]) -> String {
        let data = try! NSJSONSerialization.dataWithJSONObject(object, options: PicoApplicationContext.sharedIntance.assembly.jsonSerializationOptions)
        let serialized =  NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        return serialized.stringByReplacingOccurrencesOfString("\\/", withString: "/")
    }
    
    
}
