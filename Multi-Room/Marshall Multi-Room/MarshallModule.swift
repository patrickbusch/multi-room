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
    let inputHandler: InputHandler
    
    init(_ identifier: Identifier) {
        self._identifier = identifier
        self.settings = MarshallSettings(identifier)
        self.api = MarshallAPI()
        self.inputHandler = InputHandler(api: self.api)
        self.inputHandler.load()
        
        
        //Test Stuff
        self.settings.ipAddress = "35bf9279-5bdb-e532-85cc-f9ec2adb8d8e.local" //Test Only
        self.settings.ipAddress = "192.168.2.109" //Test Only
        //TODO Searching and IP Setting...
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
//
//                MarshallMenuItem(self._identifier, name: "Get Sysinfo", action: { () in self.api.getParams([MarshallAPIValue.SysInfoFriendlyname, .SysMode, .SysNetWlanMacaddress, .SysCapsVolumesteps], successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Mute, Volume", action: { () in self.api.getParams([MarshallAPIValue.SysAudioMute, .SysAudioVolume, .SysAudioEqcustomParam0, .SysAudioEqcustomParam1], successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Play Info", action: { () in self.api.getParams([MarshallAPIValue.PlayInfoName, .PlayInfoArtist, .PlayInfoAlbum, .PlayInfoGraphicUri, .PlayStatus, .PlayRepeat, .PlayShuffle], successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Spotify Info", action: { () in self.api.getParams([MarshallAPIValue.SpotifyPlaylistName, .SpotifyPlaylistName], successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Duration, Position", action: { () in self.api.getParams([MarshallAPIValue.PlayInfoDuration, .PlayPosition], successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Presets", action: { () in self.api.getPresets(MarshallAPIValue.NavPresets, maxItems: 7, successCallback: self.printValues)}),
//
//                MarshallMenuItem(self._identifier, name: "Get Inputs", action: { () in self.api.getInputs(MarshallAPIValue.SysCapsValidmodes, maxItems: 20, successCallback: self.printValues)}),
            ]
            
            
            //netremote.multiroom.group.state
        }
    }
    
    var views: [SHPopoverView] {
        get {
            let nowPlayingView = NowPlaying()
            let controllerView = Controller()
            let presetsView = Presets()
            
            return [
                MarshallPopoverView(self._identifier, vc: presetsView, api: self.api, inputHandler: self.inputHandler),
                MarshallPopoverView(self._identifier, vc: nowPlayingView, api: self.api, inputHandler: self.inputHandler),
                MarshallPopoverView(self._identifier, vc: controllerView, api: self.api, inputHandler: self.inputHandler),
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
    
    func printValues(_ values: [Preset]) {
        values.forEach({ (preset) in
            print("key: \(preset.key ?? -1); name: \(preset.name ?? ""); type: \(preset.type ?? ""); artworkUrl: \(preset.artworkUrl ?? "")")
        })
    }
    
    func printValues(_ values: [Input]) {
        values.forEach({ (input) in
            print("key: \(input.key ?? -1); id: \(input.id ?? ""); label: \(input.label ?? ""); selectable: \(input.selectable ?? false); streamable: \(input.streamable ?? false); modetype: \(input.modetype ?? -1)")
        })
    }
}

