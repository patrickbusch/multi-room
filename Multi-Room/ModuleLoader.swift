//
//  ModuleLoader.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class ModuleLoader {

    var modules: [SHModule] = [SHModule]()
    var updateMenus: (([Identifier: [SHMenuItem]]) -> ())?
    var updateViews: (([Identifier: [SHPopoverView]]) -> ())?
    
    func loadModules() {
        self.modules = [TestModule(Identifier("Test1")), TestModule(Identifier("Test2"))]
        
        var menuItems = [Identifier: [SHMenuItem]]()
        var views = [Identifier: [SHPopoverView]]()
        
        self.modules.forEach { (module) in
//TODO ordering
            menuItems.updateValue(module.menuItems, forKey: module.identifier)
            views.updateValue(module.views, forKey: module.identifier)
        }
        
        self.updateMenus?(menuItems)
        self.updateViews?(views)
    }
}
