//
//  UserInfoViewController.swift
//  Realm Test App
//
//  Created by scchn on 2021/4/14.
//

import Cocoa

import RealmSwift

class UserInfoViewController: NSViewController {
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    
    private var notiToken: NotificationToken?
    var userInfo: UserInfo!
    
    deinit {
        notiToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = userInfo.ofUser.first!
        
        nameTextField.stringValue = user.fullName
        label.stringValue = userInfo.number.description
        stepper.integerValue = userInfo.number
        
        notiToken = userInfo.observe { [weak self] (change: ObjectChange<UserInfo>) in
            switch change {
            case let .change(info, _):
                self?.label.stringValue = info.number.description
            default:
                break
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func stepperAction(_ sender: NSStepper) {
        try! sharedRealm.write {
            userInfo?.number = sender.integerValue
        }
    }
    
}
