//
//  ModuleLoader.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class ModuleLoader {

    func getModules() -> [SHModule] {
        
        return [SHModule]()
    }
    
    func getMenu() -> NSMenu {
        let menu = NSMenu()
        
        //        menu.addItem(NSMenuItem(title: NSLocalizedString("Do something", comment: ""), action: #selector(AppDelegate.doSomething(_:)), keyEquivalent: ""))
        //        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        return menu
    }
}
