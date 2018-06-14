//
//  Controller
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Foundation
import Cocoa

class Controller: MarshallViewController, Showable, IsClosable {
    
    var setLeftTitle: ((String) -> ())?
    
    var setRightTitle: ((String) -> ())?
    
    @IBOutlet weak var elements: NSView!
    
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var bassSlider: NSSlider!
    @IBOutlet weak var trebleSlider: NSSlider!
    
    @IBOutlet weak var volumeLabel: NSTextField!
    @IBOutlet weak var bassLabel: NSTextField!
    @IBOutlet weak var trebleLabel: NSTextField!
    

    @IBAction func volumeChanged(_ sender: NSSlider) {
        self.send(.SysAudioVolume, value: sender.doubleValue)
    }

    @IBAction func bassChanged(_ sender: NSSlider) {
        self.send(.SysAudioEqcustomParam0, value: sender.doubleValue)
    }
    
    @IBAction func trebleChanged(_ sender: NSSlider) {
        self.send(.SysAudioEqcustomParam1, value: sender.doubleValue)
    }
    
    var isShown: Bool = false {
        willSet {
            print("isShown: \(newValue)")
            if (newValue) {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.load), userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private var timer: Timer?
    
    @objc private func load() {
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname,
                             .SysAudioVolume,
                             .SysCapsVolumesteps,
                             .SysAudioEqcustomParam0,
                             .SysAudioEqcustomParam1
            ], successCallback: self.updateValues)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        self.reset()
        
        self.startLoading()
        
        self.load()
    }
    
    private func send(_ apiValue: MarshallAPIValue, value: Double) {
        let valueToSend = "\(lround(value))"
        print("\(apiValue): \(valueToSend)")
        
        self.api!.setParam(apiValue, value: valueToSend, successCallback: nil)
    }
    
    private func reset() {
        self.setLeftTitle?("")
        self.setRightTitle?(NSLocalizedString("Controller", comment: ""))
        
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
        self.setLeftTitle?(NSLocalizedString("Loading", comment: ""))
    }
    
    private func stopLoading() {
        self.elements.isHidden = false
    }
    
    private func updateValues(_ values: [MarshallAPIValue : String]) {
      
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.setLeftTitle?(kv.1)
            
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
