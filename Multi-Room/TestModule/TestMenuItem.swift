//
//  TestMenuItem.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestMenuItem: SHMenuItem {
    
    private let _identifier: String
    var name: String = ""
    var action: () -> ()
    
    init(_ identifier: String, name: String, action: @escaping () -> ()) {
        self._identifier = identifier
        self.name = name
        self.action = action
    }
    
    var identifier: String {
        get {
            return self._identifier
        }
    }
}
