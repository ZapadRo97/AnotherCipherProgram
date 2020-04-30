//
//  FileViewController.swift
//  AnotherCipherProgram
//
//  Created by Florin Daniel on 27/04/2020.
//  Copyright © 2020 Florin Daniel. All rights reserved.
//

import Cocoa

class FileViewController: NSViewController {

    var type : Type = .Crypt
    @IBOutlet weak var cryptButton: NSButton!
    @IBOutlet weak var errorLabel: NSTextField!
    @IBOutlet weak var keyTextField: NSTextField!
    
    @IBOutlet weak var inputFileTextField: NSTextField!
    @IBOutlet weak var outputDirectoryTextField: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
            do {
                let text2 = try String(contentsOf: URL(fileURLWithPath: inputFileTextField.stringValue), encoding: .utf8)
                //todo: create output file
                if type == .Crypt {
                    try cryptor.crypt(text: text2).write(to: URL(fileURLWithPath: outputDirectoryTextField.stringValue), atomically: false, encoding: .utf8)
                } else {
                    try cryptor.decrypr(text: text2).write(to: URL(fileURLWithPath: outputDirectoryTextField.stringValue), atomically: false, encoding: .utf8)
                }
                Process.launchedProcess(launchPath: "/usr/bin/open", arguments: [
                    "-a",
                    "TextEdit",
                    outputDirectoryTextField.stringValue
                ])
                
            }
            catch {
                errorLabel.stringValue = "File Error"
                errorLabel.isHidden = false
            }
        }
        else {
            errorLabel.stringValue = "Invalid Key"
            errorLabel.isHidden = false
        }
    }
    
    
    @IBAction func selectInputFileAction(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose text file to " + cryptButton.stringValue;
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false;
        dialog.allowedFileTypes        = ["txt"]

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                let path: String = result!.path
                inputFileTextField.stringValue = path
            }
            
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func selectOutputFolderAction(_ sender: Any) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Chose directory to save output";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                outputDirectoryTextField.stringValue = path + "/output.txt"
                // path contains the directory path e.g
                // /Users/ourcodeworld/Desktop/folder
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
}
