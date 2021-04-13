//
//  CreateUserViewController.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import Cocoa

class CreateUserViewController: NSViewController {
    
    @IBOutlet weak var firstNameTextField: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!
    @IBOutlet weak var ageTextField: NSTextField!
    
    var userCreated: ((User?) -> Void)?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let size = view.frame.size
        view.window?.setContentSize(size)
        view.window?.contentMinSize = size
        view.window?.contentMaxSize = size
    }
    
    private func complete(with user: User?) {
        guard let win = view.window else { return }
        userCreated?(user)
        win.sheetParent?.endSheet(win)
    }
    
    // MARK: - Actions
    
    @IBAction func okButtonAction(_ sender: Any) {
        guard !firstNameTextField.stringValue.isEmpty else {
            firstNameTextField.becomeFirstResponder()
            NSSound.beep()
            return
        }
        
        guard !lastNameTextField.stringValue.isEmpty else {
            lastNameTextField.becomeFirstResponder()
            NSSound.beep()
            return
        }
        
        guard let age = Int(ageTextField.stringValue) else {
            ageTextField.becomeFirstResponder()
            NSSound.beep()
            return
        }
        
        let user = User()
        user.firstName = firstNameTextField.stringValue
        user.lastName = lastNameTextField.stringValue
        user.age = age
        user.info = .init()
        
        complete(with: user)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        complete(with: nil)
    }
    
}
