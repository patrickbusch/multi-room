//
//  PlayState.swift
//  Multi-Room
//
//  Created by Patrick Busch on 29.05.18.
//

import Cocoa

enum Input: Int {
    
    // 1: Aux 2: Airplay 3: Spotify 5: Bluetooth 6: Radio-Streaming 7: RCA // 4: Chromecast?
    
    case AUX = 1
    case Airplay = 2
    case Spotify = 3
    case Chromecast = 4
    case Bluetooth = 5
    case InternetRadio = 6
    case RCA = 7
    case Unknown = 8 //MayBe Wifi without something playing?
    
    var playingType: PlayingType {
        get {
            switch self {
            case .AUX, .RCA, .Unknown:
                return .None
            case .InternetRadio:
                return .PlayStop
            case .Airplay, .Bluetooth, .Spotify, .Chromecast:
                return .PlayPause
            }
        }
    }
    
    var canSkip: Bool {
        get {
            switch self {
            case .AUX, .RCA, .InternetRadio, .Unknown:
                return false
            case .Airplay, .Bluetooth, .Spotify, .Chromecast:
                return true
            }
        }
    }
    
    // 0: Play/Stop (on Radio) 2: Play/Pause (on Spotify) 3: Next 4: Prev
    var playCommandValue: Int? {
        get {
            switch self.playingType {
            case .PlayStop:
                return 0
            case .PlayPause:
                return 2
            default:
                return nil
            }
        }
    }
    
    var prevCommandValue: Int? {
        if (self.canSkip) {
            return 4
        } else {
            return nil
        }
    }
    
    var nextCommandValue: Int? {
        if (self.canSkip) {
            return 3
        } else {
            return nil
        }
    }
}

enum PlayingType {
    case PlayStop
    case PlayPause
    case None
}

// 0: Nothing while Bluetooth not connected / AUX 2: Playing  / or RCA  3: Paused while spotify 6: Stopped while streaming
enum PlayState : Int {
    case Nothing = 0
    case Playing = 2
    case Paused = 3
    case Stopped = 6
}
