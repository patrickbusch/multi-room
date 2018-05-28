//
//  Controller
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Foundation
import Cocoa

class Controller: MarshallViewController {
    
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    
    @IBOutlet weak var speakerName: NSTextField!
    
    @IBOutlet weak var viewName: NSTextField!
    
    @IBOutlet weak var elements: NSView!
    
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var bassSlider: NSSlider!
    @IBOutlet weak var trebleSlider: NSSlider!
    
    @IBOutlet weak var volumeLabel: NSTextField!
    @IBOutlet weak var bassLabel: NSTextField!
    @IBOutlet weak var trebleLabel: NSTextField!
    

    @IBAction func volumeChanged(_ sender: NSSlider) {
        self.set(.SysAudioVolume, value: sender.doubleValue)
    }

    @IBAction func bassChanged(_ sender: NSSlider) {
        self.set(.SysAudioEqcustomParam0, value: sender.doubleValue)
    }
    
    @IBAction func trebleChanged(_ sender: NSSlider) {
        self.set(.SysAudioEqcustomParam1, value: sender.doubleValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        self.reset()
        
        self.startLoading()
        
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname,
                             .SysAudioVolume,
                             .SysCapsVolumesteps,
                             .SysAudioEqcustomParam0,
                             .SysAudioEqcustomParam1
            ], successCallback: self.updateValues)
    }
    
    private func set(_ apiValue: MarshallAPIValue, value: Double) {
        let valueToSend = "\(lround(value))"
        print("\(apiValue): \(valueToSend)")
        
        self.api!.setParam(apiValue, value: valueToSend, successCallback: nil)
    }
    
    private func reset() {
        self.speakerName.stringValue = ""
        self.viewName.stringValue = NSLocalizedString("Controller", comment: "")
        
        self.volumeLabel.stringValue = NSLocalizedString("Volume", comment: "")
        self.bassSlider.stringValue = NSLocalizedString("Bass", comment: "")
        self.trebleSlider.stringValue = NSLocalizedString("Treble", comment: "")

        self.volumeSlider.isEnabled = false
        self.bassSlider.isEnabled = false
        self.trebleSlider.isEnabled = false
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }
    
    
    private func startLoading() {
        self.loadingSpinner.startAnimation(nil)
        self.loadingSpinner.isHidden = false
    }
    
    private func stopLoading() {
        self.loadingSpinner.isHidden = true
        self.elements.isHidden = false
        self.loadingSpinner.stopAnimation(nil)
    }
    
    private func updateValues(_ values: [MarshallAPIValue : String]) {
      
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.speakerName.stringValue = kv.1
            
        case .SysAudioVolume:
            if let vol = Double(kv.1) {
                self.volumeSlider.doubleValue = vol
                self.volumeSlider.isEnabled = true
            } else {
                self.volumeSlider.doubleValue = 0.0
            }
            
        case .SysCapsVolumesteps:
            let steps = Double(kv.1) ?? 33.0
            
            self.volumeSlider.minValue = 0.0
            self.volumeSlider.maxValue = steps - 1
            
        case .SysAudioEqcustomParam0:
            if let val = Double(kv.1) {
                self.bassSlider.doubleValue = val
                self.bassSlider.isEnabled = true
            } else {
                self.bassSlider.doubleValue = 0.0
            }

        case .SysAudioEqcustomParam1:
            if let val = Double(kv.1) {
                self.trebleSlider.doubleValue = val
                self.trebleSlider.isEnabled = true
            } else {
                self.trebleSlider.doubleValue = 0.0
            }
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
