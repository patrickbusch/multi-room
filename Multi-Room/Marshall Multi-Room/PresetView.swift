//
//  Controller
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Foundation
import Cocoa

class PresetView: NSCollectionViewItem {
    
    @IBOutlet weak var topLabel: NSTextField!
    
    @IBOutlet weak var bottomLabel: NSTextField!
    
    @IBOutlet weak var image: NSImageView!
    private var viewHasLoaded = false
    
    var topTitle: String = "" {
        willSet {
            if (viewHasLoaded) {
                self.topLabel.stringValue = newValue
            }
        }
    }

    var bottomTitle: String = "" {
        willSet {
            if (viewHasLoaded) {
                self.bottomLabel.stringValue = newValue
            }
        }
    }
    
    var imageToShow: NSImage = #imageLiteral(resourceName: "Audio") {
        willSet {
            if (viewHasLoaded) {
                self.image.image = newValue
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
                self.topLabel.textColor = newValue
                self.bottomLabel.textColor = newValue
            }
        }
    }
    
    var target: (() -> ())?
    
    @IBAction func buttonPress(_ sender: Any) {
        self.target?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.view.backgroundColor = NSColor.clear
        self.topLabel.textColor = self.fontColor
        self.bottomLabel.textColor = self.fontColor
        self.topLabel.stringValue = self.topTitle
        self.bottomLabel.stringValue = self.bottomTitle
        self.image.image = self.imageToShow
        
        self.viewHasLoaded = true
    }
}
