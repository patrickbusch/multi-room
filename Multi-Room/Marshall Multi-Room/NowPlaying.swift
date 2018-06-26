//
//  NowPlaying.swift
//  Multi-Room
//
//  Created by Patrick Busch on 21.05.18.
//

import Foundation
import Cocoa

class NowPlaying: MarshallViewController, Showable, HasTitle {
    
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
            
            if let title = self.titleView {
                v.append(title.view)
            }
            
            if (isOpen) {
                v.append(self.view)
            }
            return v
        }
    }
    
    var isOpen: Bool = true
    
    var titleView: TableSeparator?
    
    private var timer: Timer?
    
    @objc func load() {
        
        var dataToLoad: [MarshallAPIValue]?
        
        if (isOpen) {
            dataToLoad = [MarshallAPIValue.SysInfoFriendlyname,
                          .PlayInfoName,
                          .PlayInfoAlbum,
                          .PlayInfoArtist,
                          .SysMode,
                          .PlayStatus]
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
        
        self.reset()
        
        // Do view setup here.
        self.startLoading()
        
        self.load()
    }
    
    private func reset() {
        self.view.backgroundColor = self.contentBackgroundColor
        
        self.titleView = TableSeparator()
        
        self.titleView?.leftTitle = ""
        self.titleView?.rightTitle = NSLocalizedString("Now Playing", comment: "")
        
        self.titleView?.background = self.titleBackgroundColor
        self.titleView?.fontColor = self.titleFontColor
        
        self.line1.stringValue = ""
        self.line2.stringValue = ""
        self.line3.stringValue = ""
        
        self.line1.textColor = self.contentFontColor
        self.line2.textColor = self.contentFontColor
        self.line3.textColor = self.contentFontColor

        self.line1.isHidden = true
        self.line2.isHidden = true
        self.line3.isHidden = true
        
        self.prevButton.isHidden = true
        self.nextButton.isHidden = true
        self.playButton.isHidden = true
        
        self.prevButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Prev", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
        self.nextButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Next", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }

    private func updateValues(_ values: [MarshallAPIValue : String]) {
        
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func startLoading() {
        self.titleView?.leftTitle = NSLocalizedString("Loading", comment: "")
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
                self.playButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Stop", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
            }
            self.playButton.isHidden = false
        case .PlayPause:
            if (self.currentPlayState == .Playing) {
                self.playButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Pause", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
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
            self.playButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Play", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
        case .Playing:
            if (self.currentInput?.playingType == .PlayStop) {
                self.playButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Stop", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
            } else if (self.currentInput?.playingType == .PlayPause) {
                self.playButton.attributedTitle = NSAttributedString(string: NSLocalizedString("Pause", comment: ""), attributes: [ .foregroundColor : self.contentFontColor])
            }
        default:
            print("nothing to do for play state \(playState)")
        }
        
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.titleView?.leftTitle = kv.1
            
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
