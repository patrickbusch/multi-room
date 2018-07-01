//
//  TableSeparator.swift
//  Multi-Room
//
//  Created by Patrick Busch on 14.06.18.
//

import Foundation
import Cocoa

class NowPlayingSmall: SHViewController, TableSeparator {
    
    @IBOutlet weak var left: NSTextField!

    @IBOutlet weak var prevButton: NSButton!
    
    @IBOutlet weak var playPauseButton: NSButton!
    
    @IBOutlet weak var nextButton: NSButton!
    
    @IBAction func prevButtonPressed(_ sender: NSButton) {
        self.prevButtonPressedHandler?()
    }
    
    @IBAction func playPauseButtonPressed(_ sender: NSButton) {
        self.playPauseButtonPressedHandler?()
    }
    
    @IBAction func nextButtonPressed(_ sender: NSButton) {
        self.nextButtonPressedHandler?()
    }
    
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
    
    var prevButtonImage: NSImage = #imageLiteral(resourceName: "Prev").withTintColor(tintColor: NSColor.white) {
        willSet {
            if (viewHasLoaded) {
                self.prevButton.image = newValue
            }
        }
    }
    
    var playPauseButtonImage: NSImage = #imageLiteral(resourceName: "Play").withTintColor(tintColor: NSColor.white) {
        willSet {
            if (viewHasLoaded) {
                self.playPauseButton.image = newValue
            }
        }
    }
    
    var nextButtonImage: NSImage = #imageLiteral(resourceName: "Next").withTintColor(tintColor: NSColor.white) {
        willSet {
            if (viewHasLoaded) {
                self.nextButton.image = newValue
            }
        }
    }
    
    var prevButtonPressedHandler: (() -> ())?
    var playPauseButtonPressedHandler: (() -> ())?
    var nextButtonPressedHandler: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.view.backgroundColor = self.background
        self.left.textColor = self.fontColor
        self.left.stringValue = self.leftTitle
        
        self.prevButton.image = self.prevButtonImage
        self.playPauseButton.image = self.playPauseButtonImage
        self.nextButton.image = self.nextButtonImage
        
        self.viewHasLoaded = true
    }
    
}
