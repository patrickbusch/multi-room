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
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var menu: NSMenu?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("Audio"))
            button.action = #selector(buttonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        popover.contentViewController = TestViewController.freshController()
        
//        self.constructMenu()
        
        self.menu = self.constructMenu()
        
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    // MARK: Click Handling
    @objc func buttonClicked(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
//            constructMenu()
            self.statusItem.popUpMenu(self.menu ?? NSMenu())
        } else if event.type == NSEvent.EventType.leftMouseUp {
            togglePopover(sender)
        }
    }
    
    // MARK: Menu Stuff
    @objc func doSomething(_ sender: Any?) {
        print("Button pressed")
    }
    
    func constructMenu() -> NSMenu {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: NSLocalizedString("Do something", comment: ""), action: #selector(AppDelegate.doSomething(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        return menu
//        statusItem.menu = menu
    }
    
    // MARK: Popover
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        
        eventMonitor?.stop()
    }
}

