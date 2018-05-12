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

        let views = self.vcs?.map({ (vc) -> NSView in
            return vc.view
        })
        
        var sumHeight = views?.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +) ?? 250
        
        sumHeight += (self.stackView.spacing * CGFloat((views?.count ?? 1) - 1))
        
        print(sumHeight)
        print(self.stackView.spacing)
//        print(self.stackViewHeight.constant)
//        print(self.stackViewWidth.constant)
//        print(self.stackView.frame.height)
//        print(self.stackView.frame.width)
//        print(self.stackView.bounds.height)
//        print(self.stackView.bounds.width)
//        print(self.stackView.spacing)
        
        self.popoverHeight.constant = sumHeight
        self.stackViewHeight.constant = sumHeight
 
        
//        self.stackView.frame = NSRect(x: 0, y: 0, width: MAX_WIDTH, height: sumHeight)
        
        self.scrollView.frame = NSRect(x: 0, y: 0, width: MAX_WIDTH, height: sumHeight > MAX_HEIGHT ? MAX_HEIGHT : sumHeight)
        
        self.stackView.setViews(views!, in: NSStackView.Gravity.top)

        self.stackView.updateConstraintsForSubtreeIfNeeded()

//        print(self.stackViewHeight.constant)
//        print(self.stackView.frame.height)
//        print(self.stackView.bounds.height)
//        print(self.stackView.hasAmbiguousLayout)
        
        self.stackView.views.forEach { (view) in
            print(view.frame.height)
        }

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
