//
//  PopupViewController.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopupWindowController: NSWindowController {
    
    var windowWillCloseHandler: (() -> ())?
    
    static func freshWindow() -> PopupWindowController {

        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MainWindow")
        let windowController = storyboard.instantiateController(withIdentifier: identifier) as! PopupWindowController
        
        windowController.window?.titlebarAppearsTransparent = true
        windowController.window?.backgroundColor = NSColor.black
        windowController.window?.title = NSLocalizedString("Multi-Room", comment: "")
//        windowController.window?.appearance = NSAppearance(named: .vibrantDark)
        
//        windowController.window?.titleVisibility = .hidden
//        windowController.window?.styleMask = .fullSizeContentView
        return windowController
    }
}

extension PopupWindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        self.windowWillCloseHandler?()
    }
}

class PopupViewController: NSViewController {
    
    private let MAX_HEIGHT: CGFloat = 450 //Screen height?
    private let MAX_WIDTH: CGFloat = 450
    private let MIN_HEIGHT: CGFloat = 100
    private let MIN_WIDTH: CGFloat = 200
    private let SPACE: CGFloat = 25
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var vcs: [SHViewController]?
    private var views: [NSView] {
        get {
            var views = [NSView]()
            
            self.vcs?.forEach({ (vc) in
                if let vcWithTitle = vc as? HasTitle {
                    views.append(contentsOf: vcWithTitle.views)
                } else {
                    views.append(vc.view)
                }
            })
            
            return views
        }
    }
    private var viewWasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.action = #selector(onItemClicked)
        
        self.updateViews()
        self.viewWasLoaded = true
    }

    
    private func updateViews() {

        self.view.frame = CGRect(x: 0, y: 0, width: 450, height: 180)

        var sumHeight = self.views.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +)
        
        if (sumHeight < MIN_HEIGHT) {
            sumHeight = MIN_HEIGHT
        }

        let maxWidth = self.views.map { (view) -> CGFloat in
            return view.bounds.width
            }.max() ?? MIN_WIDTH

        print("Max Width: \(maxWidth)")
        print("Sum Height: \(sumHeight)")
        
        let titleBarHeight = self.view.window?.titlebarHeight ?? 0
        
        let widthToSet = maxWidth > MAX_WIDTH ? MAX_WIDTH : maxWidth
        let heightToSet = sumHeight + titleBarHeight + SPACE > MAX_HEIGHT ? MAX_HEIGHT : sumHeight + titleBarHeight + SPACE
        
//        self.view.frame = CGRect(x: 0, y: 0,
//                                 width: widthToSet,
//                                 height: heightToSet)
        
        if var windowFrame = self.view.window?.frame {
            windowFrame.size = NSSize(width: widthToSet, height: heightToSet + (self.view.window?.titlebarHeight ?? 0))
            self.view.window?.setFrame(windowFrame, display: true)
            self.view.window?.viewsNeedDisplay = true
        }
        
        self.tableView.reloadData()
    }

    func setViews(vcs: [SHViewController]) {
        self.vcs = vcs
        
        if (viewWasLoaded) {
            updateViews()
        }
    }
}

extension PopupViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.views.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return self.views[row].frame.height
    }
    
}

extension PopupViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return self.views[row]
    }
    
    @objc private func onItemClicked() {
        print("row \(tableView.clickedRow), col \(tableView.clickedColumn) clicked")
        
        guard tableView.clickedRow >= 0 && tableView.clickedRow < self.views.count else {
            return
        }
        
        if let titleView = self.views[tableView.clickedRow] as? TitleView {
            print("istitleview")
            
            let availableVCs = self.vcs?.filter({ (vc) -> Bool in
                guard let titleVC = vc as? HasTitle else {
                    return false
                }
                
                return titleVC.titleView?.view == titleView
            })
            
            guard availableVCs?.count ?? 0 == 1 else {
                print("number of views unclear")
                return
            }
            
            var vc = availableVCs![0] as! HasTitle
            
            if (vc.isOpen) {
                vc.isOpen = false
            } else {
                vc.isOpen = true
            }
            
            self.updateViews()
        }
    }
}

extension PopupViewController {
    
    static func freshController() -> PopupViewController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PopupViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopupViewController else {
            fatalError("Why cant i find PopupViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}


