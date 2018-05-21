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
                MarshallMenuItem(self._identifier, name: "Get Overview", action: api.overview),
                
                MarshallMenuItem(self._identifier, name: "Get netremote.multiroom.group.state", action: { () in self.api.getParam(param: "netremote.multiroom.group.state")}),
                
                MarshallMenuItem(self._identifier, name: "Get Mute, Volume", action: { () in self.api.getParams([MarshallAPIValue.SysAudioMute, .SysAudioVolume], successCallback: { (results) in
                
                    let res : [MarshallAPIValue : String] = results
                    res.keys.forEach({ (key) in
                        print("\(key) : \(res[key]!)")
                    })
                    
                })}),
            ]
            
            
            //netremote.multiroom.group.state
        }
    }
    
    var views: [SHPopoverView] {
        get {
            return [SHPopoverView]()
        }
    }
    
}

