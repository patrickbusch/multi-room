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
    
    var view: NSView {get}
}

protocol Identifiable {
    
    var identifier: String {get}
}
