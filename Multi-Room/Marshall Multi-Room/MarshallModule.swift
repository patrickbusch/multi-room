//
//  MarshallModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 12.05.18.
//

import Cocoa

class MarshallModule: SHModule {
    
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
            return [SHMenuItem]()
        }
    }
    
    var views: [SHPopoverView] {
        get {
            return [SHPopoverView]()
        }
    }
    
}

