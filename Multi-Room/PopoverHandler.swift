//
//  PopoverHandler.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopoverHandler {
    
    let popover = NSPopover()
    let popupViewController: PopupViewController
    var eventMonitor: EventMonitor?
    
    var viewsLoaded: (([SHViewController]) -> ())?
    private var vcs: [SHViewController]?
    
    init() {
        self.popupViewController = PopupViewController.freshController()
        
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
        
        self.popover.contentViewController = self.popupViewController
        self.viewsLoaded = self.popupViewController.setViews
    }
    
    @objc func togglePopover(_ sender: Any?, statusBarButton: NSStatusBarButton?) {
        if self.popover.isShown {
            self.closePopover(sender: sender)
        } else {
            self.showPopover(sender: sender, statusBarButton: statusBarButton)
        }
    }
    
    private func showPopover(sender: Any?, statusBarButton: NSStatusBarButton?) {
        if let button = statusBarButton {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        
        self.eventMonitor?.start()
    }
    
    private func closePopover(sender: Any?) {
        self.popover.performClose(sender)
        
        self.eventMonitor?.stop()
    }
    
    func updateViews(_ viewCollection: SHPopoverViewCollection) {
        print("not yet implemented")
        
        var newVCs = [SHViewController]()
        
        viewCollection.forEach { (identifier, vcs) in
            
            vcs.forEach({ (view) in
                print("\(identifier): \(view.identifier)")
                
                newVCs.append(view.vc)
            })
            
//            newViews.append(SeparatorView)
            
        }
        
        self.vcs = newVCs
        self.viewsLoaded?(newVCs)
    }
}
