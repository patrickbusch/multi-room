//
//  TestViewController.swift
//  Multi-Room
//
//  Created by Patrick Busch on 01.05.18.
//

import Cocoa

class TestViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension TestViewController {
    
    // MARK: Storyboard instantiation
    static func freshController() -> TestViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "TestViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TestViewController else {
            fatalError("Why cant i find TestViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
