//
//  TableSeparator.swift
//  Multi-Room
//
//  Created by Patrick Busch on 14.06.18.
//

import Foundation
import Cocoa

class ControllerSmall: SHViewController, TableSeparator {
    
    @IBOutlet weak var left: NSTextField!
    
    @IBOutlet weak var volumeSlider: NSSlider!
    
    @IBAction func volumeChanged(_ sender: NSSlider) {
        self.volumeChangedHandler?(sender.doubleValue)
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
                if let slider = self.volumeSlider.cell as? SHSliderCell {
                    slider.color = newValue
                }
            }
        }
    }
    
    var currentVolume: Double = 0.0 {
        willSet {
            if (viewHasLoaded) {
                self.volumeSlider.doubleValue = newValue
            }
        }
    }
    
    var volumeSteps: Double = 32 {
        willSet {
            if (viewHasLoaded) {
                self.volumeSlider.maxValue = newValue
            }
        }
    }
    
    var sliderHidden: Bool = true {
        willSet {
            if (viewHasLoaded) {
                self.volumeSlider.isHidden = newValue
            }
        }
    }
    
    var sliderEnabled: Bool = false {
        willSet {
            if (viewHasLoaded) {
                self.volumeSlider.isEnabled = newValue
            }
        }
    }
    
    var volumeChangedHandler: ((Double) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.view.backgroundColor = self.background
        self.left.textColor = self.fontColor
        self.left.stringValue = self.leftTitle
        
        
        self.volumeSlider.doubleValue = self.currentVolume
        self.volumeSlider.maxValue = self.volumeSteps
        self.volumeSlider.isEnabled = self.sliderEnabled
        self.volumeSlider.isHidden = self.sliderHidden
        
        if let slider = self.volumeSlider.cell as? SHSliderCell {
            slider.color = self.fontColor
        }
        

        self.viewHasLoaded = true
    }
    
}
