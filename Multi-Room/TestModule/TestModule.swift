//
//  TestModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestModule: SHModule {

    private let _identifier: Identifier
    
    init(_ identifier: Identifier) {
        self._identifier = identifier
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
    
    var menuItems: [SHMenuItem] {
        get {
            return [
                TestMenuItem(self.identifier, name: "XXX", action: { () in print("XXX pressed in \(self.identifier)")}),
                TestMenuItem(self.identifier, name: "YYY", action: { () in print("YYY pressed in \(self.identifier)")}),
                TestMenuItem(self.identifier, name: "ZZZ", action: { () in print("ZZZ pressed in \(self.identifier)")})
            ]
        }
    }
    
    var views: [SHPopoverView] {
        get {
            return [
                TestPopoverView(self.identifier, vc: TestView1())
                ]
        }
    }

}
