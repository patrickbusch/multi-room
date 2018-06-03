//
//  NowPlaying.swift
//  Multi-Room
//
//  Created by Patrick Busch on 21.05.18.
//

import Foundation
import Cocoa

class NowPlaying: MarshallViewController {
    
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
        self.send(.PlayControl, value: self.currentInput?.prevCommandValue)
    }
    
    @IBAction func nextButtonPressed(_ sender: NSButton) {
        self.send(.PlayControl, value: self.currentInput?.nextCommandValue)
    }
    
    @IBAction func playButtonPressed(_ sender: NSButton) {
        self.send(.PlayControl, value: self.currentInput?.playCommandValue)
    }

    private var currentInput: Input? {
        willSet {
            self.setInput(newValue)
        }
    }
    
    private var currentPlayState: PlayState? {
        willSet {
            self.setPlayState(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reset()
        
        // Do view setup here.
        self.startLoading()
        
        self.api!.getParams([MarshallAPIValue.SysInfoFriendlyname,
                             .PlayInfoName,
                             .PlayInfoAlbum,
                             .PlayInfoArtist,
                             .SysMode,
                             .PlayStatus
            ], successCallback: self.updateValues)
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
        
        self.prevButton.isHidden = true
        self.nextButton.isHidden = true
        self.playButton.isHidden = true
        
        self.prevButton.title = NSLocalizedString("Prev", comment: "")
        self.nextButton.title = NSLocalizedString("Next", comment: "")
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }

    private func updateValues(_ values: [MarshallAPIValue : String]) {
        
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func startLoading() {
        self.speakerName.stringValue = NSLocalizedString("Loading", comment: "")
    }
    
    private func stopLoading() {
        self.elements.isHidden = false
    }
    
    private func send(_ apiValue: MarshallAPIValue, value: Int?) {
        
        guard let valueToSend = value else {
            print("nothing to send")
            return
        }
        
        self.api!.setParam(apiValue, value: "\(valueToSend)", successCallback: nil)
    }
    
    private func setInput(_ optInput: Input?) {
        
        guard let input = optInput else {
            print("input was not set")
            return
        }
        
        switch input.playingType {
        case .None:
            self.playButton.isHidden = true
        case .PlayStop:
            if (self.currentPlayState == .Playing) {
                self.playButton.title = NSLocalizedString("Stop", comment: "")
            }
            self.playButton.isHidden = false
        case .PlayPause:
            if (self.currentPlayState == .Playing) {
                self.playButton.title = NSLocalizedString("Pause", comment: "")
            }
            self.playButton.isHidden = false
        }
        
        self.prevButton.isHidden = !input.canSkip
        self.nextButton.isHidden = !input.canSkip
    }
    
    private func setPlayState(_ optPlayState: PlayState?) {
        
        guard let playState = optPlayState else {
            print("playState was not set")
            return
        }
        
        switch playState {
        case .Paused, .Stopped:
            self.playButton.title = NSLocalizedString("Play", comment: "")
        case .Playing:
            if (self.currentInput?.playingType == .PlayStop) {
                self.playButton.title = NSLocalizedString("Stop", comment: "")
            } else if (self.currentInput?.playingType == .PlayPause) {
                self.playButton.title = NSLocalizedString("Pause", comment: "")
            }
        default:
            print("nothing to do for play state \(playState)")
        }
        
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.speakerName.stringValue = kv.1
            
        case .PlayInfoName:
            self.line1.isHidden = false
            self.line1.stringValue = kv.1
            
        case .PlayInfoArtist:
            if (kv.1.isEmpty) {
                self.line2.isHidden = true
            } else {
                self.line2.isHidden = false
                self.line2.stringValue = kv.1
            }
            
        case .PlayInfoAlbum:
            if (kv.1.isEmpty) {
                self.line3.isHidden = true
            } else {
                self.line3.isHidden = false
                self.line3.stringValue = "\(kv.1)"
            }
            
        case .SysMode:
            let intval = Int(kv.1) ?? -1
            guard let input = Input(rawValue: intval) else {
                print("Unknown SysMode \(kv.1)")
                return
            }            
            self.currentInput = input
            
        case .PlayStatus:
            let intval = Int(kv.1) ?? 0
            guard let playState = PlayState(rawValue: intval) else {
                print("Unknown PlayState \(kv.1)")
                return
            }
            self.currentPlayState = playState
            
        default:
            print("Nothing to do for key \(kv.0)")
        }
    }
}
