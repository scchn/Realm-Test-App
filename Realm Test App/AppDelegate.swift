//
//  AppDelegate.swift
//  Realm Test App
//
//  Created by chen on 2021/4/13.
//

import Cocoa

import RealmSwift

fileprivate let schemaVersion: UInt64 = 2

fileprivate let migrationBlock: MigrationBlock = { migration, oldVersion in
    print("Schema Version: \(schemaVersion)")
    print("\tMigrating...", terminator: "")
    if oldVersion < 1 {
        migration.enumerateObjects(ofType: User.className()) { old, new in
            new?["info"] = UserInfo()
        }
    }
    if oldVersion < 2 {
        migration.renameProperty(onType: User.className(), from: "id", to: "userID")
    }
    print("done")
}

#if COMPACTION_CONDITIONAL
fileprivate let compactionBlock: (Int, Int) -> Bool = { total, used in
    let total = Double(total), used = Double(used)
    let max = Double(10) * 1024 * 1024
    let p = used / total
    print("Realm file size = \(total) Bytes")
    print("Data size       = \(used) Bytes")
    print("\t\(p * 100)%")
    return total > max && p < 0.5
}
#endif

let mainRealm: Realm = {
    let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
    let templateURL = Bundle.main.url(forResource: "default-v0", withExtension: "realm")!
    
    #if RESET_DB
    try? FileManager.default.removeItem(at: defaultURL)
    #endif
    
    // Copy if needed
    try? FileManager.default.copyItem(at: templateURL, to: defaultURL)
    
    #if COMPACTION_CONDITIONAL
    let config = Realm.Configuration(
        schemaVersion: schemaVersion,
        migrationBlock: migrationBlock,
        shouldCompactOnLaunch: compactionBlock
    )
    #elseif COMPACTION_EVERYTIME
    let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock)
    let compactedURL = defaultURL
        .deletingLastPathComponent()
        .appendingPathComponent("default-compact")
        .appendingPathExtension("realm")

    autoreleasepool {
        let realm = try! Realm(configuration: config)
        try! realm.writeCopy(toFile: compactedURL)
    }
    
    try! FileManager.default.removeItem(at: defaultURL)
    try! FileManager.default.moveItem(at: compactedURL, to: defaultURL)
    #else
    let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: migrationBlock)
    #endif
    
    return try! Realm(configuration: config)
}()

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let users = ThreadSafeReference(to: mainRealm.objects(User.self))
        
        DispatchQueue.global(qos: .background).async {
            // realm.refresh()
            do {
                let realm = try! Realm()
                if let users = realm.resolve(users) {
                    print("Cross-Thread Object:")
                    print("\tUsers: \(users.count)")
                }
            }
            
            do {
                autoreleasepool {
                    let realm = try! Realm()
                    let users = realm.objects(User.self)
                    print("From Background:")
                    print("\tUsers: \(users.count)")
                }
            }
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
}

