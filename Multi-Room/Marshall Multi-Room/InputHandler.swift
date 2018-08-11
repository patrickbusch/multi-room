//
//  InputHandler.swift
//  Multi-Room
//
//  Created by Patrick Busch on 11.08.18.
//

import Cocoa

class InputHandler {

    private let api: MarshallAPI
    private var _inputs: [Input]?
    
    var inputs: [Input] {
        get {
            if self._inputs == nil {
                self.load()
                return [Input]()
            } else {
                return self._inputs!
            }
        }
    }
    
    init(api: MarshallAPI) {
        self.api = api
    }
    
    func load() {
        self.api.getInputs(MarshallAPIValue.SysCapsValidmodes, maxItems: 20, successCallback: { (inputs) in
            self._inputs = inputs
        })
    }
    
    func byLabel(label: String) -> Input? {
        var result: Input?
        self.inputs.forEach { (input) in
            if (input.label == label) {
                result = input
            }
        }
        return result
    }
    
    func byKey(key: Int) -> Input? {
        var result: Input?
        self.inputs.forEach { (input) in
            if (input.key == key) {
                result = input
            }
        }
        return result
    }
    
}
