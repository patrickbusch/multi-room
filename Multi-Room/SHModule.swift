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
    var views: [SHPopupView] {get}
}

protocol SHMenuItem {

    var name: String {get}
    var action: () -> () {get}
}

protocol SHPopupView {
    
    var view: NSView {get}
}
