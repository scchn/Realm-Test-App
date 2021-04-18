//
//  User.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import Foundation

import RealmSwift

class User: Object {
    
    // MARK: - Schema Version 0
//    override class func primaryKey() -> String? { "id" }
    
//    @objc dynamic var id = UUID().uuidString
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var age = 0
    
    // MARK: - Schema Version 1
    @objc dynamic var info: UserInfo?
    
    // MARK: - Schema Version 2
    override class func primaryKey() -> String? { "userID" }
    
    @objc dynamic var userID = UUID().uuidString
    
    // MARK: -
    var fullName: String { firstName + " " + lastName }
    
}
