//
//  Colors.swift
//  Multi-Room
//
//  Created by Patrick Busch on 29.06.18.
//

import Cocoa

class Colors {
    
    static var windowBackground: NSColor {
        get {
            return #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        }
    }

    static var tableBackground: NSColor {
        get {
            return Colors.titleBackground
        }
    }
    
    static var titleBackground: NSColor {
        get {
            return #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }
    }
    
    static var titleFont: NSColor {
        get {
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    static var contentBackground: NSColor {
        get {
            return #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        }
    }
    
    static var contentFont: NSColor {
        get {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
