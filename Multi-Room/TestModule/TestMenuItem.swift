//
//  TestMenuItem.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestMenuItem: SHMenuItem {
    
    private let _identifier: Identifier
    var name: String = ""
    var action: () -> ()
    
    init(_ identifier: Identifier, name: String, action: @escaping () -> ()) {
        self._identifier = identifier
        self.name = name
        self.action = action
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
}
