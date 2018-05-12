//
//  TestView1.swift
//  Multi-Room
//
//  Created by Patrick Busch on 10.05.18.
//

import Cocoa

class TestView1: SHViewController {

    @IBOutlet weak var titlename: NSTextField!
    
    var textToShow: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.titlename.stringValue = self.textToShow ?? "TEXT"
        
        print("view loaded")
    }
}
