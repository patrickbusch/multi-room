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
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    private var vcs: [SHViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        

//        let views = self.vcs?.map({ (vc) -> NSView in
//            return vc.view
//        })
//        self.stackView.setViews(views!, in: NSStackView.Gravity.top)

        
        
        
        self.updateViews()
        
        print("X")
    }
    
    private func updateViews() {
        self.vcs?.forEach({ (vc) in
            self.stackView.addView(vc.view, in: .top)
        })

        let sumHeight = self.stackView.views.map { (view) -> CGFloat in
            return view.bounds.height
            }.reduce(0, +)
        
        print(sumHeight)
        
        self.contentViewHeight.constant = 700
        
        self.scrollView.needsDisplay = true
        self.scrollView.needsLayout = true
//        self.scrollView.contentSize = NSSize(width: 450, height: 700)
//        self.scrollView.documentView?.setFrameSize(NSSize(width: 450, height: 1000))
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
