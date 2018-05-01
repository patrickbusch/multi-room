//
//  ModuleLoader.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class ModuleLoader {

    var modules: [SHModule] = [SHModule]()
    var updateMenus: (([SHMenuItem]) -> ())?
    var updateViews: (([SHPopoverView]) -> ())?
    
    func loadModules() {
        self.modules = [TestModule()]
        
        var menuItems = [SHMenuItem]()
        var views = [SHPopoverView]()
        
        self.modules.forEach { (module) in
            menuItems.append(contentsOf: module.menuItems)
            views.append(contentsOf: module.views)
        }
        
        self.updateMenus?(menuItems)
        self.updateViews?(views)
    }
}
