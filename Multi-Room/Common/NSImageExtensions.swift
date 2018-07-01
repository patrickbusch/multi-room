//
//  NSImageExtensions.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.07.18.
//

import Cocoa

extension NSImage {
    func withTintColor(tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        __NSRectFillUsingOperation(NSMakeRect(0, 0, image.size.width, image.size.height), .sourceAtop)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
