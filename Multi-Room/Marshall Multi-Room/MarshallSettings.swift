
//
//  MarshallSettings.swift
//  Multi-Room
//
//  Created by Patrick Busch on 13.05.18.
//

import Cocoa

class MarshallSettings {
    
    private let _identifier: Identifier
    
    init(_ identifier: Identifier) {
        self._identifier = identifier
    }
    
    var ipAddress: String? {
        get {
            return read("ipAddress")
        }
        
        set {
            save("ipAddress", newValue)
        }
    }
    
    private func save(_ key: String, _ value: String?) {
        UserDefaults.standard.set(value, forKey: "\(self._identifier.name)_\(key)")
        UserDefaults.standard.synchronize()
    }
    
    private func read(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: "\(self._identifier.name)_\(key)")
    }

}
