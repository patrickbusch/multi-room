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
    
    var prevButtonHidden: Bool = true {
        willSet {
            if (viewHasLoaded) {
                self.prevButton.isHidden = newValue
            }
        }
    }

    var prevButtonEnabled: Bool = false {
        willSet {
            if (viewHasLoaded) {
                self.prevButton.isEnabled = newValue
            }
        }
    }

    var playPauseButtonHidden: Bool = true {
        willSet {
            if (viewHasLoaded) {
                self.playPauseButton.isHidden = newValue
            }
        }
    }
    
    var playPauseButtonEnabled: Bool = false {
        willSet {
            if (viewHasLoaded) {
                self.playPauseButton.isEnabled = newValue
            }
        }
    }
    
    var nextButtonHidden: Bool = true {
        willSet {
            if (viewHasLoaded) {
                self.nextButton.isHidden = newValue
            }
        }
    }
    
    var nextButtonEnabled: Bool = false {
        willSet {
            if (viewHasLoaded) {
                self.nextButton.isEnabled = newValue
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
        
        self.prevButton.isHidden = self.prevButtonHidden
        self.prevButton.isEnabled = self.prevButtonEnabled
        self.playPauseButton.isHidden = self.playPauseButtonHidden
        self.playPauseButton.isEnabled = self.playPauseButtonEnabled
        self.nextButton.isHidden = self.nextButtonHidden
        self.nextButton.isEnabled = self.nextButtonEnabled
        
        self.viewHasLoaded = true
    }
    
}
