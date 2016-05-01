//
//  AppDelegate.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let _ = ContainerWrapper.sharedInstance.container
        return true
    }
}

class ContainerWrapper {
    private static func isProd() -> Bool {
        return NSClassFromString("XCTestCase") == nil
    }
    static let sharedInstance = ContainerWrapper()
    var container: Container = {
        let container = Container()
        container.register(Parser.self) { _ in
            let tokenizer = Tokenizer()
            tokenizer.addTokenDefinition("(?<=@)\\w{1,}", type: .StringToken("mentions"))
            tokenizer.addTokenDefinition("(?<=\\()\\w{1,15}(?=\\))", type: .StringToken("emoticons"))
            tokenizer.addTokenDefinition("((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)", type:.URLToken("links"))
            return Parser(tokenizer: tokenizer, transformer: TokenJSONTransformer())
        }
        
        let childContainer = Container(parent: container)
        if ContainerWrapper.isProd() {
            container.register(NetworkService.self) { _ in
                return AlamofireNetworkService()
            }
        } else {
            container.register(NetworkService.self) { _ in
                return TestDummyNetworkingService()
            }
        }
        
        return container
    }()
}


