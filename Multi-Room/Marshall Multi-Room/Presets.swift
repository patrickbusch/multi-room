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

    @IBOutlet weak var presetStack: NSStackView!
    
    var isShown: Bool = false {
        willSet {
            print("isShown: \(newValue)")
            if (newValue) {
                timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.load), userInfo: nil, repeats: true)
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
    
    private func fakePresets() -> [Preset] {
        
        let preset1 = Preset()
        preset1.key = 0
        preset1.name = "Preset1"
        preset1.type = "IR"

        let preset2 = Preset()
        preset2.key = 1
        preset2.name = "Preset2"
        preset2.type = "IR"
        
        let preset3 = Preset()
        preset3.key = 2
        preset3.name = "Preset3"
        preset3.type = "Spotify"
        
        let preset4 = Preset()
        preset4.key = 3
        preset4.name = "Preset4"
        preset4.type = "Spotify"
        
        return [preset1, preset2, preset3, preset4]
    }
    
    @objc private func load() {
    
        
//        self.api!.getList(MarshallAPIValue.NavPresets, maxItems: 7, successCallback: self.showPresets)
        self.showPresets(fakePresets())
        
        var dataToLoad: [MarshallAPIValue]?
        
        if (isOpen) {
            dataToLoad = [MarshallAPIValue.SysInfoFriendlyname
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
    
    private func showPresets(_ presets: [Preset]) {
        presets.forEach { (preset) in
            print(preset.name ?? "")
            
            let presetView = PresetView()
            presetView.topTitle = preset.type ?? ""
            presetView.bottomTitle = preset.name ?? ""
            
            self.presetStack.addView(presetView.view, in: NSStackView.Gravity.leading)
        }
        
        self.stopLoading()
    }
}
