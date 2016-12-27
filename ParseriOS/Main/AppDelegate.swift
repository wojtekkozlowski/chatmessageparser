//
//  AppDelegate.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

/// TODO:
/// 1. fix tests
/// 2. fix email bug
/// 3. fix readme

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var container: Container = {
        let container = Container()
        
        container.register(Parser.self) { c in
            return Parser(tokenizer: c.resolve(Tokenizer.self)!)
        }
        
        container.register(Tokenizer.self) { _ in
            let tokenizer = Tokenizer()
            tokenizer.addTokenDefinition("(?<=@)\\w{1,}", type: .stringToken("mentions"))
            tokenizer.addTokenDefinition("(?<=\\()\\w{1,15}(?=\\))", type: .stringToken("emoticons"))
            tokenizer.addTokenDefinition("((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)", type: .urlToken("links"))
            return tokenizer
        }
        
        let childContainer = Container(parent: container)
        
        container.register(NetworkService.self) { _ in
            return AlamofireNetworkService()
        }
        return container
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }
}
