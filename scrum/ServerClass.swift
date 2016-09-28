//
//  ServerClass.swift
//  scrum
//
//  Created by Anton Shcherbakov on 24/09/2016.
//  Copyright © 2016 Styleru. All rights reserved.
//
//
import UIKit
import Alamofire
import CryptoSwift
import OneSignal

class ServerClass: NSObject {
    
    let ud: UserDefaults = UserDefaults.standard
    let serverUrl: String = "http://scrum.styleru.net/"
    
    func login(_ user: String, pass: String, completionHandler: @escaping (String?) -> ()) {
        
        let loginItems: Parameters = [
            "login":user,
            "password":pass.md5().md5()
        ]
        
        let myHeaders: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Accept":"application/json"
        ]
        
        Alamofire.request("\(serverUrl)api_auth", method: .post, parameters: loginItems, headers: myHeaders)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if (JSON as AnyObject).value(forKey: "error") is NSNull {
                        self.ud.set(((JSON as AnyObject).value(forKey: "data") as! [String:String])["id"], forKey: "id")
                        completionHandler("200")
                    } else {
                        completionHandler("sosi")
                    }
                }
                
        }
        
    }
    
    func getToDo(_ user: String, completionHandler: @escaping ([Dictionary<String,String>]) -> ()) {
        
        let userItems: Parameters = [
            "id_user": user
        ]
        
        let myHeaders: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Accept":"application/json"
        ]
        
        Alamofire.request("\(serverUrl)api_tasks", method: .post, parameters: userItems, headers: myHeaders)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if (JSON as AnyObject).value(forKey: "error") is NSNull {
                        completionHandler(((JSON as AnyObject).value(forKey: "data") as? [Dictionary<String,String>])!)
                    } else {
                        completionHandler([["":""]])
                    }
                }
        }
        
    }
    
    func getAlerts(_ user: String, completionHandler: @escaping ([Dictionary<String,String>]) -> ()) {
        
        let userItems: Parameters = [
            "id_user": user
        ]
        
        let myHeaders: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Accept":"application/json"
        ]
        
        Alamofire.request("\(serverUrl)api_notifications", method: .post, parameters: userItems, headers: myHeaders)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if (JSON as AnyObject).value(forKey: "error") is NSNull {
                        completionHandler(((JSON as AnyObject).value(forKey: "data") as? [Dictionary<String,String>])!)
                    } else {
                        completionHandler([["":""]])
                    }
                }
        }
        
    }
    
    func sendOneSignalGuid(_ user: String) {
        
        var guid = ""
        
        OneSignal.idsAvailable { (userId, token) in
            guid = userId!
        }
        
        let userItems: Parameters = [
            "id_user": user,
            "guid": guid
        ]
        
        let myHeaders: HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Accept":"application/json"
        ]
        
        Alamofire.request("\(serverUrl)api_setnotificationinfo", method: .post, parameters: userItems, headers: myHeaders).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            
            print(response.result)   // result of response serialization
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            
        }
    }
}
