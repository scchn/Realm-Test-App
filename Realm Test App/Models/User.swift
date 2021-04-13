//
//  User.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import Foundation

import RealmSwift

class User: Object {
    
    override class func primaryKey() -> String? { "id" }
    
    // Schema Version : 0
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var age = 0
    
    // Schema Version : 1
    @objc dynamic var info: UserInfo?
    
    var fullName: String { firstName + " " + lastName }
    
}
