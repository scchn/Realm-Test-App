//
//  Reusable.swift
//  Realm Test App
//
//  Created by chen on 2021/4/14.
//

import AppKit

extension NSTableView {
    
    func makeView<T: NSTableCellView>(ofType cellType: T.Type) -> T {
        let id = NSUserInterfaceItemIdentifier("\(T.self)")
        guard let view = makeView(withIdentifier: id, owner: self) as? T else {
            fatalError("Wrong NSTableCellView : \(id.rawValue)")
        }
        return view
    }
    
}
