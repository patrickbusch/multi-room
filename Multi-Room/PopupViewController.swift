//
//  PopupViewController.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopupViewController: NSViewController {
    
    private let MAX_HEIGHT: CGFloat = 450
    private let MAX_WIDTH: CGFloat = 450
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
            }.reduce(0, +) ?? 0

        let maxWidth = views?.map { (view) -> CGFloat in
            return view.bounds.width
            }.max() ?? 0
        
        self.view.frame = CGRect(x: 0, y: 0,
                                 width: maxWidth > MAX_WIDTH ? MAX_WIDTH : maxWidth,
                                 height: sumHeight + SPACE > MAX_HEIGHT ? MAX_HEIGHT : sumHeight + SPACE)

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
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PopupViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopupViewController else {
            fatalError("Why cant i find PopupViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}


