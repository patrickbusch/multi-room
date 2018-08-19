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
            
//            if let result = response.result.value {
//                print(result)
//            }
            
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
    
    func getPresets(_ param: MarshallAPIValue,  maxItems: Int,
                   successCallback: @escaping ([Preset]) -> ()) {
        
        guard let base = self.baseUrl else {
            print("Cannot continue")
            return
        }
        
        let parameters = "?pin=\(self.pin)&maxItems=\(maxItems)"
        print("\(base)LIST_GET_NEXT/\(param.rawValue)/-1\(parameters)")
        Alamofire.request("\(base)LIST_GET_NEXT/\(param.rawValue)/-1\(parameters)").responseString { (response) in
            
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                var result = [Preset]()
                
                let fsApiResponse = xml["fsapiResponse"]
                
                let state = fsApiResponse["status"].element?.text ?? ""

                guard state == self.okayState else {
                    successCallback(result)
                    return
                }
                
                
                fsApiResponse.children.filter({ (child) -> Bool in
                    child.element?.name == "item"
                }).forEach({ (item) in
                    let preset = Preset()
                    
                    preset.key = item.value(ofAttribute: "key")
                    
                    item.children.filter({ (child) -> Bool in
                        child.element?.name == "field"
                    }).forEach({ (field) in

                        do {
                            preset.name = try ((field.withAttribute("name", "name").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            preset.type = try ((field.withAttribute("name", "type").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            preset.artworkUrl = try ((field.withAttribute("name", "artworkurl").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                        } catch {
                            //do nothing
                        }
                    })
                    
                    result.append(preset)
                })

                
                successCallback(result)
            }
        }
    }
    
    func getInputs(_ param: MarshallAPIValue,  maxItems: Int,
                    successCallback: @escaping ([Input]) -> ()) {
        
        guard let base = self.baseUrl else {
            print("Cannot continue")
            return
        }
        
        let parameters = "?pin=\(self.pin)&maxItems=\(maxItems)"
        print("\(base)LIST_GET_NEXT/\(param.rawValue)/-1\(parameters)")
        Alamofire.request("\(base)LIST_GET_NEXT/\(param.rawValue)/-1\(parameters)").responseString { (response) in
            
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                var result = [Input]()
                
                let fsApiResponse = xml["fsapiResponse"]
                
                let state = fsApiResponse["status"].element?.text ?? ""
                
                guard state == self.okayState else {
                    successCallback(result)
                    return
                }
                
                
                fsApiResponse.children.filter({ (child) -> Bool in
                    child.element?.name == "item"
                }).forEach({ (item) in
                    let input = Input()
                    
                    input.key = item.value(ofAttribute: "key")
                    
                    item.children.filter({ (child) -> Bool in
                        child.element?.name == "field"
                    }).forEach({ (field) in
                        /*var key: Int?
                        var id: String?
                        var selectable: Boolean?
                        var label: String?
                        var streamable: Boolean?
                        var modetype: Int?*/
                        
                        do {
                            input.id = try ((field.withAttribute("name", "id").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            input.label = try ((field.withAttribute("name", "label").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            let text = try ((field.withAttribute("name", "selectable").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                            input.selectable = text == "1" ? true : false
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            let text = try ((field.withAttribute("name", "streamable").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                            input.streamable = text == "1" ? true : false
                        } catch {
                            //do nothing
                        }
                        
                        do {
                            let text = try ((field.withAttribute("name", "modetype").element?.children[0] as? SWXMLHash.XMLElement)?.children[0] as? TextElement)?.text ?? ""
                            input.modetype = Int(text)
                        } catch {
                            //do nothing
                        }
                        
                    })
                    
                    input.inputType = InputType2(rawValue: input.id ?? "") ?? InputType2.Unknown
                    
                    result.append(input)
                })
                
                
                successCallback(result)
            }
        }
    }
}

class Preset {
    
    var key: Int?
    var name: String?
    var type: String? //Input?
    var artworkUrl: String? {
        didSet {
            var urlToLoad = self.artworkUrl ?? ""
            if (urlToLoad.hasPrefix("http://")) {
                urlToLoad = urlToLoad.replacingOccurrences(of: "http://", with: "https://")
            }
            if let imageUrl = URL(string: urlToLoad) {
                let image = NSImage(byReferencing: imageUrl)
                
                if (image.isValid) {
                    self.image = image
                }
            }
        }
    }
    var image: NSImage?
}

class Input {
    
    var key: Int?
    var id: String?
    var selectable: Bool?
    var label: String?
    var streamable: Bool?
    var modetype: Int?
    var inputType: InputType2?
}


