//
//  TableSeparator.swift
//  Multi-Room
//
//  Created by Patrick Busch on 14.06.18.
//

import Foundation
import Cocoa

class PresetsSmall: SHViewController, TableSeparator {
    
    @IBOutlet weak var left: NSTextField!
    
    private var viewHasLoaded = false
    
    var leftTitle: String = "" {
        willSet {
            if (viewHasLoaded) {
                self.left.stringValue = newValue
            }
        }
    }
    
    var background: NSColor = NSColor.black {
        willSet {
            if (viewHasLoaded) {
                self.view.backgroundColor = newValue
            }
        }
    }
    
    var fontColor: NSColor = NSColor.white {
        willSet {
            if (viewHasLoaded) {
                self.left.textColor = newValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.view.backgroundColor = self.background
        self.left.textColor = self.fontColor
        self.left.stringValue = self.leftTitle
        
        self.viewHasLoaded = true
    }
    
}
