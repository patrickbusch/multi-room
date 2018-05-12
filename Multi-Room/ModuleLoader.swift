//
//  ModuleLoader.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

typealias SHMenuItemCollection = [(Identifier, [SHMenuItem])]
typealias SHPopoverViewCollection = [(Identifier, [SHPopoverView])]

class ModuleLoader {

    var modules: [SHModule] = [SHModule]()
    var updateMenus: ((SHMenuItemCollection) -> ())?
    var updateViews: ((SHPopoverViewCollection) -> ())?
    
    func loadModules() {
        self.modules = [TestModule(Identifier("Test1")), TestModule(Identifier("Test2")), TestModule(Identifier("Test3")), TestModule(Identifier("Test4")), TestModule(Identifier("Test5"))]
//        self.modules = [SHModule]()
        
        var menuItems =  SHMenuItemCollection()
        var views =  SHPopoverViewCollection()
        
        var i = 0
        self.modules.forEach { (module) in

            menuItems.append((module.identifier, module.menuItems))
            views.append((module.identifier, module.views))

            i += 1
        }
        
        self.updateMenus?(menuItems)
        self.updateViews?(views)
    }
}
