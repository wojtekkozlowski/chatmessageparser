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
    func getURL(_ urlString: String, completion: (_ response:String?, _ urlString: String?) -> ())
}

class AlamofireNetworkService: NetworkService {
    func getURL(_ urlString: String, completion: (String?, String?) -> ()) {
        //Alamofire.request(.GET, urlString, parameters: nil).responseString { response in
        //    completion(response: response.result.value, urlString: response.request?.URLString)
        //}
        Alamofire.request(urlString).response { response in
            //completion(response: response.result.value, urlString: response.request?.URLString)
            print(response)
        }
        
    }

    //func getURL(_ urlString: String, completion: @escaping (_ response:String?, _ urlString: String?) -> ()){
    //    Alamofire.request(.GET, urlString, parameters: nil).responseString { response in
    //        completion(response: response.result.value, urlString: response.request?.URLString)
    //    }
    //}
}

class TestDummyNetworkingService: NetworkService {
    func getURL(_ urlString: String, completion: (_ response:String?, _ urlString: String?) -> ()) {
        completion("<html><body><div class=\"tweet-text\">Sweet</div>", urlString)
    }
}

