//
//  TestMenuItem.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestMenuItem: SHMenuItem {
    
    var name: String = ""
    var action: () -> ()
    
    init(name: String, action: @escaping () -> ()) {
        self.name = name
        self.action = action
    }
}
