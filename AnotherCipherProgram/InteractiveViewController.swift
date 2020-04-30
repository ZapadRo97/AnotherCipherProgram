//
//  InteractiveViewController.swift
//  AnotherCipherProgram
//
//  Created by Florin Daniel on 27/04/2020.
//  Copyright © 2020 Florin Daniel. All rights reserved.
//

import Cocoa

class InteractiveViewController: NSViewController {

    var type : Type = .Crypt
    @IBOutlet weak var cryptButton: NSButton!
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var inputTextField: NSTextField!
    @IBOutlet weak var outputTextField: NSTextField!
    @IBOutlet weak var errorLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        outputTextField.isEditable = false
    }
    
    @IBAction func goBack(_ sender: Any) {
        if let myViewController = self.storyboard?.instantiateController(withIdentifier: "ViewController") as? ViewController {
            self.view.window?.contentViewController = myViewController
        }
    }
    
    
    @IBAction func toggleTypeAction(_ sender: Any) {
        if type == .Crypt {
            cryptButton.title = "Decrypt"
            type = .Decrypt
        } else {
            cryptButton.title = "Crypt"
            type = .Crypt
        }
    }
    
    
    @IBAction func cryptAction(_ sender: Any) {
        let cryptor = Cryptor(key: keyTextField.stringValue)
        if let cryptor = cryptor {
            errorLabel.isHidden = true
            if type == .Crypt {
                outputTextField.stringValue = cryptor.crypt(text: inputTextField.stringValue)
            } else {
                outputTextField.stringValue = cryptor.decrypr(text: inputTextField.stringValue)
            }
        } else {
            errorLabel.isHidden = false
        }
        
    }
    
}
