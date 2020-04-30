//
//  ViewController.swift
//  AnotherCipherProgram
//
//  Created by Florin Daniel on 27/04/2020.
//  Copyright © 2020 Florin Daniel. All rights reserved.
//

import Cocoa

enum Type {
    case Crypt
    case Decrypt
}

class ViewController: NSViewController {

    @IBOutlet weak var infoText: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoText.isEditable = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func interactiveButtonAction(_ sender: NSButton) {
        if let myViewController = self.storyboard?.instantiateController(withIdentifier: "InteractiveViewController") as? InteractiveViewController {
            self.view.window?.contentViewController = myViewController
        }
    }
    
    
    @IBAction func fileButtonAction(_ sender: NSButton) {
        if let myViewController = self.storyboard?.instantiateController(withIdentifier: "FileViewController") as? FileViewController {
            self.view.window?.contentViewController = myViewController
        }
    }
    
}

