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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do view setup here.
        self.startLoading()

        self.speakerName.stringValue = ""
        self.viewName.stringValue = NSLocalizedString("Controller", comment: "")
        self.elements.backgroundColor = NSColor.yellow
        
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
