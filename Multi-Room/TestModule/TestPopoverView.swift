//
//  TestPopoverView.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestPopoverView: SHPopoverView {
    
    private let _identifier: String
    var view: NSView
    
    init(_ identifier: String, view: NSView) {
        self._identifier = identifier
        self.view = view
    }
    
    var identifier: String {
        get {
            return self._identifier
        }
    }
}
