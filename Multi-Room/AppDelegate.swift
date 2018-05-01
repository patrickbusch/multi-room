//
//  AppDelegate.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let moduleLoader = ModuleLoader()
    let popoverHandler = PopoverHandler()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Audio"))
            button.action = #selector(buttonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    // MARK: Click Handling
    @objc func buttonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            self.statusItem.popUpMenu(moduleLoader.getMenu())
        } else if event.type == NSEvent.EventType.leftMouseUp {
            popoverHandler.togglePopover(sender, statusBarButton: statusItem.button)
        }
    }
    
}

