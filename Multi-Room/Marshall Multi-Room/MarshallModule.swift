//
//  MarshallModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 12.05.18.
//

import Cocoa

class MarshallModule: SHModule {
    
    private let _identifier: Identifier
    let settings: MarshallSettings
    
    init(_ identifier: Identifier) {
        self._identifier = identifier
        self.settings = MarshallSettings(identifier)
        self.settings.ipAddress = "192.168.2.116" //Test Only
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
    
    var menuItems: [SHMenuItem] {
        get {
            return [SHMenuItem]()
        }
    }
    
    var views: [SHPopoverView] {
        get {
            return [SHPopoverView]()
        }
    }
    
}

