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
    
    @IBOutlet weak var volumeLabel: NSTextField!
    
    @IBAction func volumeChanged(_ sender: NSSlider) {
        self.set(.SysAudioVolume, value: sender.doubleValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        self.reset()
        
        self.startLoading()
        
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname,
                             .SysAudioVolume,
                             .SysCapsVolumesteps], successCallback: self.updateValues)
    }
    
    private func set(_ apiValue: MarshallAPIValue, value: Double) {
        let valueToSend = "\(lround(value))"
        print("\(apiValue): \(valueToSend)")
        
    }
    
    private func reset() {
        self.speakerName.stringValue = ""
        self.viewName.stringValue = NSLocalizedString("Controller", comment: "")
        
        self.volumeLabel.stringValue = NSLocalizedString("Volume", comment: "")

        self.volumeSlider.isEnabled = false
        
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
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
