//
//  MenuHandler.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class MenuAction {
    
    var action: () -> ()
    
    init(action: @escaping () -> ()) {
        self.action = action
    }
    
    @objc func doAction() {
        self.action()
    }
}

class MenuHandler {

    var menuLoaded: ((NSMenu) -> ())?
    var menuActions: [MenuAction] = [MenuAction]()
    
    var defaultMenu: NSMenu {
        get {
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            return menu
        }
    }
    
    
    func updateMenu(_ menuItems: [SHMenuItem]) {
        let menu = NSMenu()
        var menuActions = [MenuAction]()
        
        menuItems.forEach { (menuItem) in
            let menuAction = MenuAction(action: menuItem.action)
            let newMenuItem = NSMenuItem(title: NSLocalizedString(menuItem.name, comment: ""), action: #selector(MenuAction.doAction), keyEquivalent: "")
            
            newMenuItem.target = menuAction
            
            menuActions.append(menuAction)
            menu.addItem(newMenuItem)
        }
        
        menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.menuActions = menuActions
        self.menuLoaded?(menu)
    }
}
