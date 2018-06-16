//
//  PopupView.swift
//  Multi-Room
//
//  Created by Patrick Busch on 16.06.18.
//

import Cocoa

class PopoverContentView : NSView {
    
    var backgroundView:PopoverBackgroundView?
    
    override func viewDidMoveToWindow() {
        
        super.viewDidMoveToWindow()
        
        if let frameView = self.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = PopoverBackgroundView(frame: frameView.bounds)
                backgroundView!.autoresizingMask = NSView.AutoresizingMask([.width, .height]);
                frameView.addSubview(backgroundView!, positioned: NSWindow.OrderingMode.below, relativeTo: frameView)
            }
        }
    }
}

class PopoverBackgroundView : NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSColor.black.set()
        let rect = NSRect(origin: self.bounds.origin, size: self.bounds.size)
        rect.fill()
    }
}
