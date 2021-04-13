//
//  UserInfo.swift
//  Realm Test App
//
//  Created by scchn on 2021/4/14.
//

import Foundation

import RealmSwift

class UserInfo: Object {
    
    @objc dynamic var number = 0
    
    let ofUser = LinkingObjects(fromType: User.self, property: "info")
    
}
