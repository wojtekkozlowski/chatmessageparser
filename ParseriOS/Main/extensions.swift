//
//  extensions.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 27/12/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

extension Dictionary {
    func serialize() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [JSONSerialization.WritingOptions.prettyPrinted])
        let serialized = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return serialized.replacingOccurrences(of: "\\/", with: "/")
    }
}
