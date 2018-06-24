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
        windowController.window?.appearance = NSAppearance(named: .vibrantDark)
        
        return windowController
    }
}

extension PopupWindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        self.windowWillCloseHandler?()
    }
}

class PopupViewController: NSViewController {
    
    private let MAX_HEIGHT: CGFloat = 450
    private let MAX_WIDTH: CGFloat = 450
    private let MIN_HEIGHT: CGFloat = 100
    private let MIN_WIDTH: CGFloat = 200
    private let SPACE: CGFloat = 10
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var vcs: [SHViewController]?
    private var viewWasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.updateViews()
        self.viewWasLoaded = true
    }

    
    private func updateViews() {

        self.view.frame = CGRect(x: 0, y: 0, width: 450, height: 180)

        let views = self.vcs?.map({ (vc) -> NSView in
            return vc.view
        })

        let sumHeight = views?.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +) ?? MIN_HEIGHT

        let maxWidth = views?.map { (view) -> CGFloat in
            return view.bounds.width
            }.max() ?? MIN_WIDTH

        print("Max Width: \(maxWidth)")
        print("Sum Height: \(sumHeight)")
        
        let widthToSet = maxWidth > MAX_WIDTH ? MAX_WIDTH : maxWidth
        let heightToSet = sumHeight + SPACE > MAX_HEIGHT ? MAX_HEIGHT : sumHeight + SPACE
        
        self.view.frame = CGRect(x: 0, y: 0,
                                 width: widthToSet,
                                 height: heightToSet)
        
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
        return self.vcs?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return self.vcs?[row].view.frame.height ?? 0
    }
    
}

extension PopupViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let item = self.vcs?[row] else {
            return nil
        }

        return item.view
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


