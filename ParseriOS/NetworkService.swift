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
    func getURL(_ urlString: String, completion: @escaping (_ response:String?, _ urlString: String?) -> ())
}

class AlamofireNetworkService: NetworkService {
    func getURL(_ urlString: String, completion: @escaping (String?, String?) -> ()) {
        Alamofire.request(urlString).responseString { response in
            completion(response.result.value, response.request?.url?.absoluteString)
        }
    }
}

class TestDummyNetworkingService: NetworkService {
    func getURL(_ urlString: String, completion: @escaping (_ response:String?, _ urlString: String?) -> ()) {
        completion("<html><body><div class=\"tweet-text\">Sweet</div>", urlString)
    }
}

