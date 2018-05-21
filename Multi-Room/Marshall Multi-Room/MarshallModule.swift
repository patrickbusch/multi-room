//
//  MarshallModule.swift
//  Multi-Room
//
//  Created by Patrick Busch on 12.05.18.
//

import Cocoa

class MarshallModule: SHModule {
    
    private let _identifier: Identifier
    let settings: MarshallSettings
    let api: MarshallAPI
    
    init(_ identifier: Identifier) {
        self._identifier = identifier
        self.settings = MarshallSettings(identifier)
        self.api = MarshallAPI()
        
        //Test Stuff
        self.settings.ipAddress = "192.168.2.116" //Test Only
        self.api.ipAddress = self.settings.ipAddress
    }
    
    var identifier: Identifier {
        get {
            return self._identifier
        }
    }
    
    var menuItems: [SHMenuItem] {
        get {
            return [

                MarshallMenuItem(self._identifier, name: "Get Sysinfo", action: { () in self.api.getParams([MarshallAPIValue.SysInfoFriendlyname, .SysMode, .SysNetWlanMacaddress, .SysCapsVolumesteps], successCallback: self.printValues)}),
                                
                MarshallMenuItem(self._identifier, name: "Get Mute, Volume", action: { () in self.api.getParams([MarshallAPIValue.SysAudioMute, .SysAudioVolume, .SysAudioEqcustomParam0, .SysAudioEqcustomParam1], successCallback: self.printValues)}),
                
                MarshallMenuItem(self._identifier, name: "Get Play Info", action: { () in self.api.getParams([MarshallAPIValue.PlayInfoName, .PlayInfoArtist, .PlayInfoAlbum, .PlayInfoGraphicUri, .PlayStatus, .PlayRepeat, .PlayShuffle], successCallback: self.printValues)}),
                
                MarshallMenuItem(self._identifier, name: "Get Spotify Info", action: { () in self.api.getParams([MarshallAPIValue.SpotifyPlaylistName, .SpotifyPlaylistName], successCallback: self.printValues)}),
                
                MarshallMenuItem(self._identifier, name: "Get Duration, Position", action: { () in self.api.getParams([MarshallAPIValue.PlayInfoDuration, .PlayPosition], successCallback: self.printValues)}),
                
            ]
            
            
            //netremote.multiroom.group.state
        }
    }
    
    var views: [SHPopoverView] {
        get {
            let nowPlayingView = NowPlaying()
            
            return [
                MarshallPopoverView(self.identifier, vc: nowPlayingView)
            ]
        }
    }
    
}

extension MarshallModule {
    
    func printValues(_ values: [MarshallAPIValue : String]) {
        values.keys.forEach({ (key) in
            print("\(key) : \(values[key]!)")
        })
    }
}

