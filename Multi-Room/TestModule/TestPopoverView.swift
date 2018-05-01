//
//  TestPopoverView.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestPopoverView: SHPopoverView {
    
    var view: NSView
    
    init(view: NSView) {
        self.view = view
    }
}
