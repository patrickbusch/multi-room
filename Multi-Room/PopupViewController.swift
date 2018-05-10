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

    @IBOutlet weak var popoverWidth: NSLayoutConstraint!
    @IBOutlet weak var popoverHeight: NSLayoutConstraint!

    private let MAX_HEIGHT: CGFloat = 450
    private let MAX_WIDTH: CGFloat = 450
    
    private var vcs: [SHViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        


        
        
        
        self.updateViews()
        
        print("X")
    }
    
    private func updateViews() {
//        self.vcs?.forEach({ (vc) in
//            self.stackView.addView(vc.view, in: .top)
//        })
        let views = self.vcs?.map({ (vc) -> NSView in
            return vc.view
        })
        self.stackView.setViews(views!, in: NSStackView.Gravity.top)


        let sumHeight = self.stackView.views.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +)
        
        print(sumHeight)
        
        self.popoverHeight.constant = sumHeight
        self.stackViewHeight.constant = sumHeight
        
        self.scrollView.frame = NSRect(x: 0, y: 0, width: MAX_WIDTH, height: sumHeight > MAX_HEIGHT ? MAX_HEIGHT : sumHeight)
        
//        self.scrollView.contentView.scroll(NSPoint(x: 0, y: 0))
//        self.scrollView.documentView?.scroll(NSPoint.zero)
    }
    
    //TODO refresh
    func setViews(vcs: [SHViewController]) {
        self.vcs = vcs
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
