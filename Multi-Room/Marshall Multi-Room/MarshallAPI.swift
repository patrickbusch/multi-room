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
    
    func overview() {
        
        guard let base = self.baseUrl else {
            return
        }
        
        
//        let parameters: Parameters = ["pin": "1234",
//                                      "node": "netremote.multiroom.group.id",
//                                      "node": "netremote.multiroom.group.state",
//                                      "node": "netremote.multiroom.device.clientindex",
//                                      "node": "netremote.multiroom.device.listallversion"]
        // non-standard API
        let parameters: String = "?pin=1234&node=netremote.multiroom.group.id&node=netremote.multiroom.group.state&node=netremote.multiroom.group.name&node=netremote.multiroom.device.clientindex&node=netremote.multiroom.device.listallversion"
        
        Alamofire.request("\(base)GET_MULTIPLE\(parameters)").responseString { (response) in

            if let result = response.result.value {
                print(result)
            }
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                print(xml["fsapiGetMultipleResponse"]["fsapiResponse"][0]["status"].element?.text ?? "")
            }
        }
    }
    
    func getParam(param: String) {
        
        guard let base = self.baseUrl else {
            return
        }
        

        
        let parameters: String = "?pin=1234&node=\(param)"

        Alamofire.request("\(base)GET_MULTIPLE\(parameters)").responseString { (response) in
            
            if let result = response.result.value {
                print(result)
            }
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                print(xml["fsapiGetMultipleResponse"]["fsapiResponse"][0]["status"].element?.text ?? "")
            }
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
    
    private func buildGetParams(_ params: [MarshallAPIValue]) -> String {
        
        var getParams = ""
        params.forEach { (value) in
            getParams.append("&node=\(value.rawValue)")
        }
        
        return getParams
    }
}
