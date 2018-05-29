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
    
    @IBOutlet weak var speakerName: NSTextField!
    
    @IBOutlet weak var viewName: NSTextField!
    
    @IBOutlet weak var elements: NSView!
    
    @IBOutlet weak var line1: NSTextField!
    
    @IBOutlet weak var line2: NSTextField!
    
    @IBOutlet weak var line3: NSTextField!
    

    @IBOutlet weak var prevButton: NSButton!
    
    @IBOutlet weak var nextButton: NSButton!
    
    @IBOutlet weak var playButton: NSButton!
    
    @IBAction func prevButtonPressed(_ sender: NSButton) {
    }
    
    @IBAction func nextButtonPressed(_ sender: NSButton) {
    }
    
    @IBAction func playButtonPressed(_ sender: NSButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reset()
        
        // Do view setup here.
        self.startLoading()
        
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname, .PlayInfoName, .PlayInfoAlbum, .PlayInfoArtist], successCallback: self.updateValues)
    }
    
    private func reset() {
        self.speakerName.stringValue = ""
        self.viewName.stringValue = NSLocalizedString("Now Playing", comment: "")
        
        self.line1.stringValue = ""
        self.line2.stringValue = ""
        self.line3.stringValue = ""

        self.line1.isHidden = true
        self.line2.isHidden = true
        self.line3.isHidden = true
        
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
        case .PlayInfoName:
            self.line1.isHidden = false
            self.line1.stringValue = kv.1
        case .PlayInfoArtist:
            self.line2.isHidden = false
            self.line2.stringValue = kv.1
        case .PlayInfoAlbum:
            self.line3.isHidden = false
            self.line3.stringValue = "(\(kv.1))"
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
