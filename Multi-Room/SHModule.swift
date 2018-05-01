//
//  SHModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

protocol SHModule {

    var identifier: String {get}
    var menuItems: [SHMenuItem] {get}
    var views: [SHPopoverView] {get}
}

protocol SHMenuItem {

    var name: String {get}
    var action: () -> () {get}
}

protocol SHPopoverView {
    
    var view: NSView {get}
}
