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
    private var menu: NSMenu?
    private var menuActions: [MenuAction] = [MenuAction]()
    
    var defaultMenu: NSMenu {
        get {
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            return menu
        }
    }
    
    
    func updateMenu(_ menuItems: SHMenuItemCollection) {
        let menu = NSMenu()
        var menuActions = [MenuAction]()
        
        menuItems.forEach { (identifier, menuItems) in
            
            menuItems.forEach({ (menuItem) in
                print("\(identifier): \(menuItem.name)")
                
                let menuAction = MenuAction(action: menuItem.action)
                let newMenuItem = NSMenuItem(title: NSLocalizedString(menuItem.name, comment: ""), action: #selector(MenuAction.doAction), keyEquivalent: "")
                
                newMenuItem.target = menuAction
                
                menuActions.append(menuAction)
                menu.addItem(newMenuItem)
            })
            
            menu.addItem(NSMenuItem.separator())
            
        }
        
        if (menuItems.count > 0) {
            menu.addItem(NSMenuItem.separator())
        }
        
        menu.addItem(NSMenuItem(title: NSLocalizedString("Quit application", comment: ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        self.menuActions = menuActions
        self.menu = menu
        self.menuLoaded?(menu)
    }
}
