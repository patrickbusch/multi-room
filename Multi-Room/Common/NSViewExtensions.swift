//
//  NSViewExtensions.swift
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Cocoa

extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}
