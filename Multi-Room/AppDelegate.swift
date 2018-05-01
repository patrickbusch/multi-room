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
    let menuHandler = MenuHandler()
    let popoverHandler = PopoverHandler()
    var menu: NSMenu?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        moduleLoader.updateMenus = { (menuItems) in self.menuHandler.updateMenu(menuItems) }
        moduleLoader.updateViews = { (views) in self.popoverHandler.updateViews(views) }
        menuHandler.menuLoaded = { (menu) in self.menu = menu }
//        popoverHandler.viewsLoaded
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Audio"))
            button.action = #selector(buttonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        moduleLoader.loadModules()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func buttonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            self.statusItem.popUpMenu(self.menu ?? self.menuHandler.defaultMenu)
        } else if event.type == NSEvent.EventType.leftMouseUp {
            popoverHandler.togglePopover(sender, statusBarButton: statusItem.button)
        }
    }

}

