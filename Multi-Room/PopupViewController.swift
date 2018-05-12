//
//  PopupViewController.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class PopupViewController: NSViewController {
    
    @IBOutlet var stackView: NSStackView!
    @IBOutlet var scrollView: NSScrollView!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!

    private let MAX_HEIGHT: CGFloat = 450
    private let MAX_WIDTH: CGFloat = 450
    private let SPACE: CGFloat = 20
    
    private var vcs: [SHViewController]?
    private var viewWasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        

        self.installStackView()
        self.updateViews()
        self.viewWasLoaded = true
    }
    
    private func installStackView() {
        self.scrollView.documentView = self.stackView
        
        let leading = NSLayoutConstraint(item: self.stackView, attribute: .leading, relatedBy: .equal, toItem: self.scrollView, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: self.stackView, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1, constant: 10)
        
        self.scrollView.addConstraint(leading)
        self.scrollView.addConstraint(top)
    }
    
    
    private func updateViews() {

        let views = self.vcs?.map({ (vc) -> NSView in
            return vc.view
        })
        
        var sumHeight = views?.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +) ?? 250
        
        let maxWidth = views?.map { (view) -> CGFloat in
            return view.bounds.width
            }.max() ?? 250
        
        sumHeight += (self.stackView.spacing * CGFloat((views?.count ?? 1) - 1))
        
        self.stackViewHeight.constant = sumHeight
        self.stackViewWidth.constant = maxWidth
        
        //hinder scrolling
        let viewHeight = sumHeight + 2
        let viewWidth = maxWidth + 2
        
        self.scrollView.frame = NSRect(x: 0, y: 0,
                                       width: viewWidth > MAX_WIDTH ? MAX_WIDTH : viewWidth,
                                       height: viewHeight > MAX_HEIGHT ? MAX_HEIGHT : viewHeight)

        self.stackView.setViews(views!, in: NSStackView.Gravity.top)
        
        self.stackView.views.forEach { (view) in
            print(view.frame.height)
        }

    }
    
    func setViews(vcs: [SHViewController]) {
        self.vcs = vcs
        
        if (viewWasLoaded) {
            updateViews()
        }
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
