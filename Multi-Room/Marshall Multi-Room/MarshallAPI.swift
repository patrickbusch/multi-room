//
//  MarshallAPI.swift
//  Multi-Room
//
//  Created by Patrick Busch on 13.05.18.
//

import Cocoa
import Alamofire
import SWXMLHash

class MarshallAPI {

    let pin = "1234"
    let okayState = "FS_OK"
    
    var ipAddress: String?
    var baseUrl: String? {
        get {
            guard let ip = self.ipAddress else {
                return nil
            }
            
            return "http://\(ip)/fsapi/"
        }
    }
    
    func getParams(_ params: [MarshallAPIValue],
                   successCallback: @escaping ([MarshallAPIValue : String]) -> ()) {
        
        guard let base = self.baseUrl else {
            print("Cannot continue")
            return
        }
    
        let parameters = "?pin=\(self.pin)\(self.buildGetParams(params))"
        
        Alamofire.request("\(base)GET_MULTIPLE\(parameters)").responseString { (response) in
            
            if let result = response.result.value {
                print(result)
            }
            
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                var result = [MarshallAPIValue : String]()
                
                xml["fsapiGetMultipleResponse"].children.forEach({ (fsapiResponse) in
                    
                    let state = fsapiResponse["status"].element?.text ?? ""
                    let node = fsapiResponse["node"].element?.text ?? ""
                    let value = fsapiResponse["value"].children[0].element?.text ?? ""
                    
                    guard let apiValue = MarshallAPIValue(rawValue: node) else {
                        print("Unknown API value \(node)")
                        return
                    }
                    
                    if (state == self.okayState) {
                        print("\(apiValue) : \(value)")
                        result[apiValue] = value
                    } else {
                        print("\(apiValue) : \(state)")
                    }
                })
                
                successCallback(result)
            }
        }
    }
    
    func setParam(_ param: MarshallAPIValue, value: String, successCallback: (() -> ())?) {
        
        guard let base = self.baseUrl else {
            print("Cannot continue")
            return
        }
        
        let parameters = "\(param.rawValue)?pin=\(self.pin)&value=\(value)"
        
        Alamofire.request("\(base)SET/\(parameters)").response { (response) in
            if (response.error == nil) {
                successCallback?()
            }
        }
        
    }
    private func buildGetParams(_ params: [MarshallAPIValue]) -> String {
        
        var getParams = ""
        params.forEach { (value) in
            getParams.append("&node=\(value.rawValue)")
        }
        
        return getParams
    }
}
