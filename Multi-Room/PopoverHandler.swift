//
//  PopoverHandler.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopoverHandler {
    
    let windowController: PopupWindowController
    let popupViewController: PopupViewController
    
    var viewsLoaded: (([SHViewController]) -> ())?
    private var vcs: [SHViewController]?
    
    var isShown: Bool = false {
        willSet {
            self.vcs?.forEach({ (vc) in
                
                if var showable = vc as? Showable {
                    showable.isShown = newValue
                }
            })
        }
    }
    
    init() {
        
        self.windowController = PopupWindowController.freshWindow()
        
        self.popupViewController = self.windowController.window!.contentViewController as! PopupViewController
        
        self.viewsLoaded = self.popupViewController.setViews
        
        self.windowController.windowWillCloseHandler = self.windowClosed
    }
    
    func show() {
        
        if (self.isShown) {
            self.windowToForeground()
            NSApp.activate(ignoringOtherApps: true)
        } else {
            self.showWindow()
        }
    }
    
    private func windowToForeground() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func showWindow() {
        self.windowController.showWindow(self)
        self.isShown = true
        self.windowToForeground()
    }
    
    private func windowClosed() {
        self.isShown = false
    }
    
    func updateViews(_ viewCollection: SHPopoverViewCollection) {
        
        var newVCs = [SHViewController]()
        
        viewCollection.forEach { (identifier, vcs) in
            
            vcs.forEach({ (view) in
                print("\(identifier): \(view.identifier)")
                
                if var viewWithTitle = view.vc as? IsClosable {
                    let titleView = TableSeparator()
                    
                    viewWithTitle.setLeftTitle = { (title) in
                        titleView.left.stringValue = title
                    }

                    viewWithTitle.setRightTitle = { (title) in
                        titleView.right.stringValue = title
                    }
                    
                    viewWithTitle.setTitleBackgroundColor = { (color) in
                        titleView.view.backgroundColor = color
                    }
                    
                    viewWithTitle.setTitleTextColor = { (color) in
                        titleView.left.textColor = color
                        titleView.right.textColor = color
                    }
                    
                    newVCs.append(titleView)
                }

                newVCs.append(view.vc)
            })
            
//            newViews.append(SeparatorView)
            
        }
        
        self.vcs = newVCs
        self.viewsLoaded?(newVCs)
    }
}
