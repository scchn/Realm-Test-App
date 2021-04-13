//
//  AppDelegate.swift
//  Realm Test App
//
//  Created by chen on 2021/4/13.
//

import Cocoa

import RealmSwift

fileprivate let schemaVersion: UInt64 = 1

fileprivate let migrationBlock: MigrationBlock = { migration, oldVersion in
    print("Migrating...", terminator: "")
    if oldVersion < 1 {
        migration.enumerateObjects(ofType: User.className()) { old, new in
            new?["info"] = UserInfo()
        }
    }
    print("done!")
}

let sharedRealm: Realm = {
    let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
    let dstURL = defaultURL.deletingLastPathComponent()
        .appendingPathComponent("default")
        .appendingPathExtension("realm")
    let srcURL = Bundle.main.url(forResource: "default-v0", withExtension: "realm")!
    
    #if RESET_DB
    try? FileManager.default.removeItem(at: dstURL)
    #endif
    
    try? FileManager.default.copyItem(at: srcURL, to: dstURL)
    
    let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock)
    
    return try! Realm(configuration: config)
}()

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

