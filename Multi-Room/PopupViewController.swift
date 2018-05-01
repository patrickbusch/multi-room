//
//  PopupViewController.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

import Cocoa

class PopupViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
