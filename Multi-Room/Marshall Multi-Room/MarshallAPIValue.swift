//
//  MarshallAPIValue.swift
//  Multi-Room
//
//  Created by Patrick Busch on 21.05.18.
//

import Cocoa

enum MarshallAPIValue : String {
    
    //getting stuff
    
    //GET_MULTIPLE, GET
    case SysMode = "netremote.sys.mode"
    
    //LIST_GET_NEXT/netremote.sys.caps.validmodes/-1?pin=1234&maxItems=20
    // 0: Audsync 1: AUXIN 2: Airplay 3: Spotify 4: Google Cast 5: Bluetooth 6: IR 7: RCA 8: Standby 9: castsetup-default
    
    case SysInfoFriendlyname = "netremote.sys.info.friendlyname"
    case SysNetWlanMacaddress = "netremote.sys.net.wlan.macaddress"
    case SysInfoNetremotevendorid = "netremote.sys.info.netremotevendorid"
    case SysAudioVolume = "netremote.sys.audio.volume" //Can be set
    case SysCapsVolumesteps = "netremote.sys.caps.volumesteps"
    case SysAudioMute = "netremote.sys.audio.mute" //Can be set
    case SysAudioEqcustomParam0 = "netremote.sys.audio.eqcustom.param0" //Can be set
    case SysAudioEqcustomParam1 = "netremote.sys.audio.eqcustom.param1" //Can be set
    case SysPower = "netremote.sys.power"
    case SysInfoVersion = "netremote.sys.info.version"
    case MultiroomGroupMastervolume = "netremote.multiroom.group.mastervolume"
    case MultiroomDeviceClientindex = "netremote.multiroom.device.clientindex"
    case MultiroomDeviceListallversion = "netremote.multiroom.device.listallversion"
    case MultiroomGroupId = "netremote.multiroom.group.id"
    case MultiroomGroupName = "netremote.multiroom.group.name"
    case MultiroomGroupState = "netremote.multiroom.group.state"
    case PlatformOEMColorProduct = "netRemote.platform.OEM.colorProduct"
    case NavPresetCurrentpreset = "netremote.nav.preset.currentpreset"
    case PlayStatus = "netremote.play.status" // 0: Nothing while Bluetooth not connected / AUX 2: Playing  / or RCA  3: Paused while spotify 6: Stopped while streaming
    case PlayCaps = "netremote.play.caps"
    case PlayInfoDuration = "netremote.play.info.duration"
    case PlayInfoGraphicUri = "netremote.play.info.graphicuri"
    case PlayInfoArtist = "netremote.play.info.artist"
    case PlayInfoAlbum = "netremote.play.info.album"
    case PlayInfoName = "netremote.play.info.name"
    case PlayPosition = "netremote.play.position"
    case PlayShuffle = "netremote.play.shuffle"
    case PlayRepeat = "netremote.play.repeat"
    case SpotifyPlaylistName = "netremote.spotify.playlist.name"
    case SpotifyPlaylistUri = "netremote.spotify.playlist.uri"
    
    
    //setting stuff & other
    
    //LIST_GET_NEXT
    
    /*
     curl -v "http://192.168.2.121/fsapi/LIST_GET_NEXT/netremote.nav.presets/-1?pin=1234&maxItems=7"
     curl -v "http://192.168.2.116/fsapi/LIST_GET_NEXT/netremote.bluetooth.connecteddevices/-1?pin=1234&maxItems=20"
     curl -v "http://192.168.2.116/fsapi/LIST_GET_NEXT/netremote.multiroom.device.listall/-1?pin=1234&maxItems=20"
     curl -v "http://192.168.2.116/fsapi/LIST_GET_NEXT/netremote.sys.caps.validmodes/-1?pin=1234&maxItems=20"
     */
    
    case NavPresets = "netremote.nav.presets"
    case BluetoothConnectedDevices = "netremote.bluetooth.connecteddevices"
    case MultiroomDeviceListall = "netremote.multiroom.device.listall"
    case SysCapsValidmodes = "netremote.sys.caps.validmodes"
    
    
    // SET
    case NavActionSelectPreset = "netremote.nav.action.selectpreset" //seems to be counting up from 0
    case NavState = "netremote.nav.state" // 1 on selecting preset
    case PlayControl = "netremote.play.control" // 0: Play/Stop (on Radio) 2: Play/Pause (on Spotify) 3: Next 4: Prev
    
    
    /*
     curl -v "http://192.168.2.121/fsapi/CREATE_SESSION?pin=1234"
     curl -v "http://192.168.2.121/fsapi/GET_NOTIFIES?pin=1234&sid=527929965d"
     */
}

