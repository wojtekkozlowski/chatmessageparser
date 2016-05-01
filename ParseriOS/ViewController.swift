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
    
    var parser: Parser = ContainerWrapper.sharedInstance.container.resolve(Parser.self)!
    
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

