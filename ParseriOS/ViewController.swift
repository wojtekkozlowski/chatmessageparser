//
//  ViewController.swift
//  ParseriOS
//
//  Created by Wojtek Kozlowski on 28/04/2016.
//  Copyright © 2016 Wojtek Kozlowski. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var parseButton: UIButton!
    
    var parser: Parser = ContainerWrapper.sharedInstance.container.resolve(Parser.self)!
    
    @IBAction func parsePressed(_ sender: AnyObject) {
        if let text = self.textInputField.text {
            self.parseButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            self.textView.text = nil
            
            _ = firstly {
                self.parser.parse(text)
            }.then { tokensDictionary in
                //self.parseButton.setTitleColor(self.parseButton.tintColor, for: .normal)
                self.textView.text = tokensDictionary.description
            }
        }
    }
    
    override func viewDidLoad() {
        self.textInputField.text = "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"
        
    }
}

