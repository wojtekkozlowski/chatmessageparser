//
//  PicoApplicationContext.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 30/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation
import Alamofire

class PicoApplicationContext {
    
    static let sharedIntance = PicoApplicationContext()
    let assembly: Assembly
    
    init(){
        if NSClassFromString("XCTestCase") == nil {
            self.assembly = ProdAssembly()
        } else {
            self.assembly = TestAssembly()
        }
    }
}

protocol NetworkService {
    func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ())
}

protocol Assembly:class {
    var networkService: NetworkService { get }
    var jsonSerializationOptions: NSJSONWritingOptions { get }
}

class ProdAssembly: Assembly {
    let networkService: NetworkService = AlamofireNetworkService()
    var jsonSerializationOptions: NSJSONWritingOptions  {
        return NSJSONWritingOptions.PrettyPrinted
    }
    
    class AlamofireNetworkService: NetworkService {
        func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ()){
            Alamofire.request(.GET, urlString, parameters: nil).responseString { response in
                completion(response: response.result.value, urlString: response.request?.URLString)
            }
        }
    }
}

class TestAssembly: Assembly {
    let networkService: NetworkService = TestDummyNetworkingService()
    
    var jsonSerializationOptions: NSJSONWritingOptions  {
        return []
    }
    
    class TestDummyNetworkingService: NetworkService {
        func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ()) {
            completion(response: "<html><body><div class=\"tweet-text\">Sweet</div>", urlString: urlString)
        }
    }
}
