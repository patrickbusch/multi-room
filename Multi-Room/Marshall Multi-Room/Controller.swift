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
    
    @IBOutlet weak var volumeSlider: SHSlider!
    @IBOutlet weak var bassSlider: SHSlider!
    @IBOutlet weak var trebleSlider: SHSlider!
    
    @IBOutlet weak var volumeLabel: NSTextField!
    @IBOutlet weak var bassLabel: NSTextField!
    @IBOutlet weak var trebleLabel: NSTextField!
    

    @IBAction func volumeChanged(_ sender: SHSlider) {
        sender.recolorTickMarks()
        self.send(.SysAudioVolume, value: sender.doubleValue)
    }
    
    @IBAction func bassChanged(_ sender: SHSlider) {
        sender.recolorTickMarks()
        self.send(.SysAudioEqcustomParam0, value: sender.doubleValue)
    }
    
    @IBAction func trebleChanged(_ sender: SHSlider) {
        sender.recolorTickMarks()
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
    
    let defaultTableSeparator = DefaultTableSeparator()
    let controllerSmall = ControllerSmall()
    var titleView: TableSeparator {
        get {
            
            if (isOpen) {
                return self.defaultTableSeparator
            } else {
                return self.controllerSmall
            }
            
        }
    }
    
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
            dataToLoad = [.SysAudioVolume]
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
        
        self.defaultTableSeparator.leftTitle = ""
        self.defaultTableSeparator.rightTitle = NSLocalizedString("Controller", comment: "")
        self.defaultTableSeparator.background = self.titleBackgroundColor
        self.defaultTableSeparator.fontColor = self.titleFontColor
        
        self.controllerSmall.leftTitle = ""
        self.controllerSmall.background = self.titleBackgroundColor
        self.controllerSmall.fontColor = self.titleFontColor
        self.controllerSmall.activeColor = self.activeColor
        
        self.controllerSmall.sliderEnabled = false
        self.controllerSmall.sliderHidden = true
        self.controllerSmall.volumeChangedHandler = { (value) in
           self.send(.SysAudioVolume, value: value)
        }
        
        self.volumeLabel.stringValue = NSLocalizedString("Volume", comment: "")
        self.bassLabel.stringValue = NSLocalizedString("Bass", comment: "")
        self.trebleLabel.stringValue = NSLocalizedString("Treble", comment: "")
        
        self.volumeLabel.textColor = self.contentFontColor
        self.bassLabel.textColor = self.contentFontColor
        self.trebleLabel.textColor = self.contentFontColor

        self.volumeSlider.isEnabled = false
        self.bassSlider.isEnabled = false
        self.trebleSlider.isEnabled = false
        
        self.volumeSlider.inactiveColor = self.contentFontColor
        self.bassSlider.inactiveColor = self.contentFontColor
        self.trebleSlider.inactiveColor = self.contentFontColor
        
        self.volumeSlider.activeColor = self.activeColor
        self.bassSlider.activeColor = self.activeColor
        self.trebleSlider.activeColor = self.activeColor
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }
    
    private func startLoading() {
        self.defaultTableSeparator.leftTitle = NSLocalizedString("Loading", comment: "")
        self.controllerSmall.leftTitle = NSLocalizedString("Loading", comment: "")
    }
    
    private func stopLoading() {
        self.elements.isHidden = false
        self.controllerSmall.sliderHidden = false
    }
    
    private func updateValues(_ values: [MarshallAPIValue : String]) {
      
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.defaultTableSeparator.leftTitle = kv.1
            self.controllerSmall.leftTitle = NSLocalizedString("Volume", comment: "")
            
        case .SysAudioVolume:
            if let vol = Double(kv.1) {
                self.volumeSlider.doubleValue = vol
                self.volumeSlider.isEnabled = true
                
                self.controllerSmall.currentVolume = vol
                self.controllerSmall.sliderEnabled = true
            } else {
                self.volumeSlider.doubleValue = 0.0
                self.controllerSmall.currentVolume = 0.0
            }
            
            self.volumeSlider.recolorTickMarks()
            
        case .SysCapsVolumesteps:
            let steps = Double(kv.1) ?? 33.0
            
            self.volumeSlider.minValue = 0.0
            self.volumeSlider.maxValue = steps - 1
            self.controllerSmall.volumeSteps = steps - 1
            
        case .SysAudioEqcustomParam0:
            if let val = Double(kv.1) {
                self.bassSlider.doubleValue = val
                self.bassSlider.isEnabled = true
            } else {
                self.bassSlider.doubleValue = 0.0
            }
            
            self.bassSlider.recolorTickMarks()

        case .SysAudioEqcustomParam1:
            if let val = Double(kv.1) {
                self.trebleSlider.doubleValue = val
                self.trebleSlider.isEnabled = true
            } else {
                self.trebleSlider.doubleValue = 0.0
            }
            
            self.trebleSlider.recolorTickMarks()
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
