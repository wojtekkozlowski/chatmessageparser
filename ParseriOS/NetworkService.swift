//
//  NetworkService.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 01/05/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import Foundation

import Alamofire

protocol NetworkService {
    func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ())
}

class AlamofireNetworkService: NetworkService {
    func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ()){
        Alamofire.request(.GET, urlString, parameters: nil).responseString { response in
            completion(response: response.result.value, urlString: response.request?.URLString)
        }
    }
}

class TestDummyNetworkingService: NetworkService {
    func getURL(urlString: String, completion: (response:String?, urlString: String?) -> ()) {
        completion(response: "<html><body><div class=\"tweet-text\">Sweet</div>", urlString: urlString)
    }
}

