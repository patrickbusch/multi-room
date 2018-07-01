//
//  Controller
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Foundation
import Cocoa

class Controller: MarshallViewController, Showable, HasTitle {
    
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

    var views: [NSView] {
        get {
            var v = [NSView]()
            
            v.append(self.titleView.view)
            
            if (isOpen) {
                v.append(self.view)
            }
            return v
        }
    }
    
    var isOpen: Bool = true
    
    var titleView: TableSeparator = DefaultTableSeparator()
    
    private var timer: Timer?
    
    @objc private func load() {
        
        var dataToLoad: [MarshallAPIValue]?
        
        if (isOpen) {
            dataToLoad = [MarshallAPIValue.SysInfoFriendlyname,
                          .SysAudioVolume,
                          .SysCapsVolumesteps,
                          .SysAudioEqcustomParam0,
                          .SysAudioEqcustomParam1
            ]
        } else {
            dataToLoad = []
        }
        
        guard dataToLoad?.count ?? 0 > 0 else {
            print("nothing to load")
            return
        }
        
        self.api!.getParams(dataToLoad!, successCallback: self.updateValues)
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
        self.view.backgroundColor = self.contentBackgroundColor
        
        self.titleView.leftTitle = ""
        self.titleView.rightTitle = NSLocalizedString("Controller", comment: "")
        
        self.titleView.background = self.titleBackgroundColor
        self.titleView.fontColor = self.titleFontColor
        
        self.volumeLabel.stringValue = NSLocalizedString("Volume", comment: "")
        self.bassLabel.stringValue = NSLocalizedString("Bass", comment: "")
        self.trebleLabel.stringValue = NSLocalizedString("Treble", comment: "")
        
        self.volumeLabel.textColor = self.contentFontColor
        self.bassLabel.textColor = self.contentFontColor
        self.trebleLabel.textColor = self.contentFontColor

        self.volumeSlider.isEnabled = false
        self.bassSlider.isEnabled = false
        self.trebleSlider.isEnabled = false
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }
    
    
    private func startLoading() {
        self.titleView.leftTitle = NSLocalizedString("Loading", comment: "")
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
            self.titleView.leftTitle = kv.1
            
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
