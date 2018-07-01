//
//  SHModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

protocol SHModule : Identifiable {

    var menuItems: [SHMenuItem] {get}
    var views: [SHPopoverView] {get}
}

protocol SHMenuItem : Identifiable {

    var name: String {get}
    var action: () -> () {get}
}

protocol SHPopoverView : Identifiable {
    
    var vc: SHViewController {get}
}

class SHViewController : NSViewController {
}

protocol Showable {
    
    var isShown: Bool {get set}
}

protocol TableSeparator {
    
    var view: NSView {get set}
//    var leftTitle: String {get set}
//    var rightTitle: String {get set}
    var background: NSColor {get set}
    var fontColor: NSColor {get set}
    
}

protocol HasTitle {
    
    var titleView: TableSeparator {get}
    var views: [NSView] {get}
    var isOpen: Bool {get set}
}

protocol Identifiable {
    
    var identifier: Identifier {get}
}

class Identifier {
    
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
}

extension Identifier : Hashable {
    
    var hashValue: Int {
        return name.hashValue
    }
}

extension Identifier : Equatable {
    
    static func ==(lhs: Identifier, rhs: Identifier) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Identifier : CustomStringConvertible {
    
    var description: String {
        get {
            return self.name
        }
    }
}
