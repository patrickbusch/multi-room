//
//  Enums.swift
//  Multi-Room
//
//  Created by Patrick Busch on 29.05.18.
//

import Cocoa

enum InputType2: String {
    
    // read via LIST_GET_NEXT/netremote.sys.caps.validmodes/-1?pin=1234&maxItems=20
    //0: Audsync 1: AUXIN 2: Airplay 3: Spotify 4: Google Cast 5: Bluetooth 6: IR 7: RCA 8: Standby 9: castsetup-default
    
    case Audsync = "Audsync"
    case AUX = "AUXIN"
    case Airplay = "Airplay"
    case Spotify = "Spotify"
    case GoogleCast = "Google Cast"
    case Bluetooth = "Bluetooth"
    case InternetRadio = "IR"
    case RCA = "RCA"
    case Standby = "Standby"
    case castsetup = "castsetup-default"
    case Unknown = "Unknown"
    
    var playingType: PlayingType {
        get {
            switch self {
            case .AUX, .RCA, .Standby, .castsetup, .Audsync, .Unknown:
                return .None
            case .InternetRadio:
                return .PlayStop
            case .Airplay, .Bluetooth, .Spotify, .GoogleCast:
                return .PlayPause
            }
        }
    }
    
    var canSkip: Bool {
        get {
            switch self {
            case .AUX, .RCA, .InternetRadio, .Audsync, .Standby, .castsetup, .Unknown:
                return false
            case .Airplay, .Bluetooth, .Spotify, .GoogleCast:
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
