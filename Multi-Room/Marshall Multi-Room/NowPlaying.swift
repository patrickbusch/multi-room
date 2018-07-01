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
    
    private var currentInfo: String = "" {
        didSet {
            self.setAggregatedPlayInfo()
        }
    }

    private var currentArtist: String = "" {
        didSet {
            self.setAggregatedPlayInfo()
        }
    }
    
    private var currentAlbum: String = "" {
        didSet {
            self.setAggregatedPlayInfo()
        }
    }
    
    func setAggregatedPlayInfo () {
        
        var aggInfo = self.currentInfo
        
        if (!self.currentArtist.isEmpty) {
            aggInfo.append(" | \(self.currentArtist)")
        }
        
        if (!self.currentAlbum.isEmpty) {
            aggInfo.append(" | \(self.currentAlbum)")
        }
        
        self.nowPlayingSmall.leftTitle = aggInfo
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
    let nowPlayingSmall = NowPlayingSmall()
    var titleView: TableSeparator {
        get {
            
            if (isOpen) {
                return self.defaultTableSeparator
            } else {
                return self.nowPlayingSmall
            }
            
        }
    }
    
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
            dataToLoad = [.PlayInfoName,
                          .PlayInfoAlbum,
                          .PlayInfoArtist,
                          .SysMode,
                          .PlayStatus]
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

        self.defaultTableSeparator.leftTitle = ""
        self.defaultTableSeparator.rightTitle = NSLocalizedString("Now Playing", comment: "")
        self.defaultTableSeparator.background = self.titleBackgroundColor
        self.defaultTableSeparator.fontColor = self.titleFontColor
        
        self.nowPlayingSmall.leftTitle = ""
        self.nowPlayingSmall.background = self.titleBackgroundColor
        self.nowPlayingSmall.fontColor = self.titleFontColor
        
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
        
        self.prevButton.image = #imageLiteral(resourceName: "Prev").withTintColor(tintColor: self.contentFontColor)
        self.nextButton.image = #imageLiteral(resourceName: "Next").withTintColor(tintColor: self.contentFontColor)
        
        self.nowPlayingSmall.prevButtonImage = #imageLiteral(resourceName: "Prev").withTintColor(tintColor: self.titleFontColor)
        self.nowPlayingSmall.nextButtonImage = #imageLiteral(resourceName: "Next").withTintColor(tintColor: self.titleFontColor)
        self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Play").withTintColor(tintColor: self.titleFontColor)
        
        self.nowPlayingSmall.prevButtonPressedHandler = { () in
            self.send(.PlayControl, value: self.currentInput?.prevCommandValue)
        }

        self.nowPlayingSmall.nextButtonPressedHandler = { () in
            self.send(.PlayControl, value: self.currentInput?.nextCommandValue)
        }
        
        self.nowPlayingSmall.playPauseButtonPressedHandler = { () in
            self.send(.PlayControl, value: self.currentInput?.playCommandValue)
        }
        
        self.elements.isHidden = true
        self.elements.backgroundColor = NSColor.clear
    }

    private func updateValues(_ values: [MarshallAPIValue : String]) {
        
        values.forEach(update)
        
        self.stopLoading()
    }
    
    private func startLoading() {
        self.defaultTableSeparator.leftTitle = NSLocalizedString("Loading", comment: "")
        self.nowPlayingSmall.leftTitle = NSLocalizedString("Loading", comment: "")
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
                self.playButton.image = #imageLiteral(resourceName: "Stop").withTintColor(tintColor: self.contentFontColor)
                self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Stop").withTintColor(tintColor: self.titleFontColor)
            }
            self.playButton.isHidden = false
        case .PlayPause:
            if (self.currentPlayState == .Playing) {
                self.playButton.image = #imageLiteral(resourceName: "Pause").withTintColor(tintColor: self.contentFontColor)
                self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Pause").withTintColor(tintColor: self.titleFontColor)
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
            self.playButton.image = #imageLiteral(resourceName: "Play").withTintColor(tintColor: self.contentFontColor)
            self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Play").withTintColor(tintColor: self.titleFontColor)
        case .Playing:
            if (self.currentInput?.playingType == .PlayStop) {
                self.playButton.image = #imageLiteral(resourceName: "Stop").withTintColor(tintColor: self.contentFontColor)
                self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Stop").withTintColor(tintColor: self.titleFontColor)
            } else if (self.currentInput?.playingType == .PlayPause) {
                self.playButton.image = #imageLiteral(resourceName: "Pause").withTintColor(tintColor: self.contentFontColor)
                self.nowPlayingSmall.playPauseButtonImage = #imageLiteral(resourceName: "Pause").withTintColor(tintColor: self.titleFontColor)
            }
        default:
            print("nothing to do for play state \(playState)")
        }
        
    }
    
    private func update(_ kv: (MarshallAPIValue, String)) {
        switch kv.0 {
        case .SysInfoFriendlyname:
            self.defaultTableSeparator.leftTitle = kv.1
            
        case .PlayInfoName:
            self.line1.isHidden = false
            self.line1.stringValue = kv.1
            self.currentInfo = kv.1
            
        case .PlayInfoArtist:
            if (kv.1.isEmpty) {
                self.line2.isHidden = true
                self.currentArtist = ""
            } else {
                self.line2.isHidden = false
                self.line2.stringValue = kv.1
                self.currentArtist = kv.1
            }
            
        case .PlayInfoAlbum:
            if (kv.1.isEmpty) {
                self.line3.isHidden = true
                self.currentAlbum = ""
            } else {
                self.line3.isHidden = false
                self.line3.stringValue = "\(kv.1)"
                self.currentAlbum = kv.1
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
