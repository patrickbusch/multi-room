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
        
        func setShowingState(_ val: Bool) {
            self.vcs?.forEach({ (vc) in
                
                if var showable = vc as? Showable {
                    showable.isShown = val
                }
            })
        }
        
        if self.popover.isShown {
            self.closePopover(sender: sender)
            setShowingState(false)
        } else {
            self.showPopover(sender: sender, statusBarButton: statusBarButton)
            setShowingState(true)
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
