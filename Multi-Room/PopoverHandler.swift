//
//  PopoverHandler.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopoverHandler {
    
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
//    var viewsLoaded: ((NSView) -> ())?
    
    init() {
        self.eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
        self.popover.contentViewController = PopupViewController.freshController()
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
    
    func updateViews(_ views: [Identifier: [SHPopoverView]]) {
        print("not yet implemented")
    }
}
