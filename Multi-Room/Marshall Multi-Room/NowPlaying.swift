//
//  NowPlaying.swift
//  Multi-Room
//
//  Created by Patrick Busch on 21.05.18.
//

import Foundation
import Cocoa

class NowPlaying: MarshallViewController {
    
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    
    @IBOutlet weak var speakerName: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.startLoading()
        
        self.speakerName.stringValue = "YYY"
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname], successCallback: self.updateValues)
    }
    
    private func startLoading() {
        self.loadingSpinner.startAnimation(nil)
        self.loadingSpinner.isHidden = false
    }
    
    private func stopLoading() {
        self.loadingSpinner.isHidden = true
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
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
