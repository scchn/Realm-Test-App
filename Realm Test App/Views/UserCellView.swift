//
//  UserCellView.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import Cocoa

class UserCellView: NSTableCellView {
    
    var infoButtonClicked: ((NSButton) -> Void)?
    
    func setup(user: User) {
        textField?.stringValue = "(\(user.age)) \(user.fullName)"
    }
    
    @IBAction func infoButtonAction(_ sender: NSButton) {
        infoButtonClicked?(sender)
    }
    
}
