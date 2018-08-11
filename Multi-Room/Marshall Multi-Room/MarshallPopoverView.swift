//
//  MarshallView.swift
//  Multi-Room
//
//  Created by Patrick Busch on 21.05.18.
//

import Cocoa

class MarshallPopoverView: SHPopoverView {

    private let _identifier: Identifier
    var vc: SHViewController
    
    init(_ identifier: Identifier, vc: SHViewController, api: MarshallAPI, inputHandler: InputHandler) {
        self._identifier = identifier
        self.vc = vc
        (self.vc as? MarshallViewController)?.api = api
        (self.vc as? MarshallViewController)?.inputHandler = inputHandler
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
}
