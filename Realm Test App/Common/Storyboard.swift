//
//  Storyboard.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import Cocoa

enum Storyboard: String {
    
    case Main = "Main"
    
    var instance: NSStoryboard { NSStoryboard(name: rawValue, bundle: nil) }
    
}

//

protocol StoryboardInstantiable {
    
    static func instantiate(from storyboard: Storyboard) -> Self
    
}

extension StoryboardInstantiable {
    
    static func instantiate(from storyboard: Storyboard) -> Self {
        storyboard.instance.instantiateController(withIdentifier: "\(self)") as! Self
    }
    
}

//

extension NSViewController: StoryboardInstantiable { }

extension NSWindowController: StoryboardInstantiable { }
