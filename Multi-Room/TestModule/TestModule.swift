//
//  TestModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestModule: NSObject, SHModule {

    var identifier: String {
        get {
            return "Test"
        }
    }
    
    var menuItems: [SHMenuItem] {
        get {
            return [
                TestMenuItem(name: "XXX", action: { () in print("XXX pressed")}),
                TestMenuItem(name: "YYY", action: { () in print("YYY pressed")}),
                TestMenuItem(name: "ZZZ", action: { () in print("ZZZ pressed")})
            ]
        }
    }
    
    var views: [SHPopoverView] {
        get {
            return [TestPopoverView]()
        }
    }

}
