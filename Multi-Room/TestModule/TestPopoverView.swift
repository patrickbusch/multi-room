//
//  TestPopoverView.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestPopoverView: SHPopoverView {
    
    private let _identifier: Identifier
    var view: NSView
    
    init(_ identifier: Identifier, view: NSView) {
        self._identifier = identifier
        self.view = view
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
}
