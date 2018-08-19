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

    @IBOutlet weak var collectionView: NSCollectionView!

    private var presetViews: [PresetView] = [PresetView]()
    private var presets: [Preset] = [Preset]()
    
    var isShown: Bool = false {
        willSet {
            print("isShown: \(newValue)")
            if (newValue) {
                timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.load), userInfo: nil, repeats: true)
                presetTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.checkNavAndLoad), userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                presetTimer?.invalidate()
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
    private var presetTimer: Timer?

    @objc private func checkNavAndLoad() {
        self.checkNavState()
    }
    
    @objc private func load() {
        
        var dataToLoad: [MarshallAPIValue]?
        
        if (isOpen) {
            dataToLoad = [.SysInfoFriendlyname,
                          .SysMode
            ]
        } else {
            dataToLoad = [.SysMode]
        }
        
        guard dataToLoad?.count ?? 0 > 0 else {
            print("nothing to load")
            return
        }
        
        self.api!.getParams(dataToLoad!, successCallback: self.updateValues)
    }
    
    private func checkNavState() {
        self.api!.getParams([.NavState]) { (kvPairs) in
            kvPairs.forEach({ (kv: (MarshallAPIValue, String)) in
                if (kv.0 == .NavState) {
                    if (kv.1 == "1") {
                        self.loadPresets()
                    }
                    if (kv.1 == "0") {
                        self.unlockNav()
                    }
                }
            })
        }
    }
    
    private func unlockNav() {
        self.api!.setParam(MarshallAPIValue.NavState, value: "1") {
            self.loadPresets()
        }
    }
    
    private func loadPresets() {
        self.api!.getPresets(MarshallAPIValue.NavPresets, maxItems: 7, successCallback: self.showPresets)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.reset()
        
        self.startLoading()
        
        self.load()
        self.checkNavAndLoad()
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
           
        case .SysMode:
            let intval = Int(kv.1) ?? -1
            
            guard let input = self.inputHandler!.byKey(key: intval) else {
                print("Unknown SysMode \(kv.1)")
                return
            }
            
            self.defaultTableSeparator.rightTitle = input.label ?? ""
            self.presetsSmall.rightTitle = input.label ?? ""
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
    
    private func showPresets(_ presets: [Preset]) {
  
        self.presets = presets
        self.collectionView.reloadData()
        self.stopLoading()
        
//        if presets.count > 0 {
////            self.presetStack.subviews.forEach({ (subview) in
////                self.presetStack.removeView(subview)
////            })
//            self.presetViews.removeAll()
//        }
//
//
////        presets.forEach { (preset) in
////            print(preset.name ?? "")
////
////            let presetView = PresetView()
////            presetView.topTitle = preset.type ?? ""
////            presetView.bottomTitle = preset.name ?? ""
////            var artworkUrl = preset.artworkUrl ?? ""
////            if (artworkUrl.hasPrefix("http://")) {
////                artworkUrl = artworkUrl.replacingOccurrences(of: "http://", with: "https://")
////            }
////            if let imageUrl = URL(string: artworkUrl) {
////                let image = NSImage(byReferencing: imageUrl)
////
////                if (image.isValid) {
////                    presetView.image = image
////                }
////            }
        
//            presetView.target = { () in
//                self.api!.setParam(.NavActionSelectPreset, value: "\(preset.key ?? -1)", successCallback: { () in
//                    self.unlockNav() // don't know why this is needed - but node needs to be unblocked...
//                })
//            }
        
            
//            self.presetViews.append(presetView)
            
//            self.presetStack.addView(presetView.view, in: NSStackView.Gravity.leading)
//            self.collectionView.addSubview(presetView.view)
//        }

    }

}

extension Presets: NSCollectionViewDataSource {
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presets.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let presetView = self.collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PresetView"), for: indexPath
            ) as! PresetView
        
        let preset = self.presets[indexPath.item]
        
        print(preset.name ?? "")

        presetView.topTitle = preset.type ?? ""
        presetView.bottomTitle = preset.name ?? ""
        var artworkUrl = preset.artworkUrl ?? ""
        if (artworkUrl.hasPrefix("http://")) {
            artworkUrl = artworkUrl.replacingOccurrences(of: "http://", with: "https://")
        }
        if let imageUrl = URL(string: artworkUrl) {
            let image = NSImage(byReferencing: imageUrl)

            if (image.isValid) {
                presetView.image = image
            }
        }
        
        presetView.target = { () in
            self.api!.setParam(.NavActionSelectPreset, value: "\(preset.key ?? -1)", successCallback: { () in
                self.unlockNav() // don't know why this is needed - but node needs to be unblocked...
            })
        }
        
        return presetView
    }
}

extension Presets: NSCollectionViewDelegate {
}
