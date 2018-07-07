//
//  Controller
//  Multi-Room
//
//  Created by Patrick Busch on 26.05.18.
//

import Foundation
import Cocoa

class Presets: MarshallViewController, Showable, HasTitle {
    
    @IBOutlet weak var elements: NSView!

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
    let presetsSmall = PresetsSmall()
    var titleView: TableSeparator {
        get {
            
            if (isOpen) {
                return self.defaultTableSeparator
            } else {
                return self.presetsSmall
            }
            
        }
    }
    
    private var timer: Timer?
    
    @objc private func load() {
//        
//        var dataToLoad: [MarshallAPIValue]?
//        
//        if (isOpen) {
//            dataToLoad = [MarshallAPIValue.SysInfoFriendlyname,
//                          .SysAudioVolume,
//                          .SysCapsVolumesteps,
//                          .SysAudioEqcustomParam0,
//                          .SysAudioEqcustomParam1
//            ]
//        } else {
//            dataToLoad = [.SysAudioVolume]
//        }
//        
//        guard dataToLoad?.count ?? 0 > 0 else {
//            print("nothing to load")
//            return
//        }
//        
//        self.api!.getParams(dataToLoad!, successCallback: self.updateValues)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        
        self.reset()
        
        self.startLoading()
        
        self.load()
    }
    
//    private func send(_ apiValue: MarshallAPIValue, value: Double) {
//        let valueToSend = "\(lround(value))"
//        print("\(apiValue): \(valueToSend)")
//
//        self.api!.setParam(apiValue, value: valueToSend, successCallback: nil)
//    }
    
    private func reset() {
        self.view.backgroundColor = self.contentBackgroundColor
        
        self.defaultTableSeparator.leftTitle = ""
        self.defaultTableSeparator.rightTitle = NSLocalizedString("Presets", comment: "")
        self.defaultTableSeparator.background = self.titleBackgroundColor
        self.defaultTableSeparator.fontColor = self.titleFontColor
        
        self.presetsSmall.leftTitle = ""
        self.presetsSmall.background = self.titleBackgroundColor
        self.presetsSmall.fontColor = self.titleFontColor
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }
    
    
    private func startLoading() {
        self.defaultTableSeparator.leftTitle = NSLocalizedString("Loading", comment: "")
        self.presetsSmall.leftTitle = NSLocalizedString("Loading", comment: "")
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
            self.defaultTableSeparator.leftTitle = kv.1
            self.presetsSmall.leftTitle = NSLocalizedString("Presets", comment: "")
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
