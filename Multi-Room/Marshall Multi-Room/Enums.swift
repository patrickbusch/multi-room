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
