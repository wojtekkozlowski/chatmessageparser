//
//  ViewController.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import UIKit
import Alamofire
import FutureKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var parseButton: UIButton!
    
    private let parser: Parser
    
    required init?(coder aDecoder: NSCoder) {
        let tokenizer = Tokenizer()
        tokenizer.addTokenDefinition("(?<=@)(\\w|\\d){1,}", type: .StringToken("mentions"))
        tokenizer.addTokenDefinition("(?<=\\()\\w{1,15}(?=\\))", type: .StringToken("emoticons"))
        tokenizer.addTokenDefinition("((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((?:\\/[\\+~%\\/\\.\\w\\-_]*)?\\??(?:[\\-\\+=&;%@\\.\\w_]*)#?(?:[\\.\\!\\/\\\\w]*))?)", type:.URLToken("links"))
         self.parser = Parser(tokenizer: tokenizer, transformer: TokenJSONTransformer())
        super.init(coder: aDecoder)
    }
    
    @IBAction func parsePressed(sender: AnyObject) {
        if let text = self.textInputField.text {
            self.parseButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            self.textView.text = nil
            self.parser.parse(text).onSuccess {
                self.parseButton.setTitleColor(self.parseButton.tintColor, forState: .Normal)
                self.textView.text = $0
            }
        }
    }
    
    override func viewDidLoad() {
        self.textInputField.text = "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"
        
    }
}

