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
    
    var playingType: PlayingType {
        get {
            switch self {
            case .AUX, .RCA:
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
            case .AUX, .RCA, .InternetRadio:
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

enum PlayState {
    case Playing
    case Paused
    case Stopped
}
