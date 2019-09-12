//
//  RequestService.swift
//  RequestNow
//
//  Created by Nicole Klein on 9/12/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON


class RequestService {
    
    var defaults = UserDefaults.standard
    static let instance = RequestService()
    var requests: [Request]?
    
    func getRequests(eventKey: Int, completion: @escaping CompletionHandler) {
        Alamofire.request(EVENT_DATA + "?event_key=" + String(eventKey), method: .get, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
            
            if response.result.error == nil {
                print(response.result)
                print("Success! Got all requests")
                dump(response.result.value)
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["message"].string  == "Internal server error" {
                        completion(false)
                    }
                    else{
                        let requestResponse: Requests = data
                        self.requests = requestResponse.requestList
                         UserDefaults.standard.set(eventKey, forKey: "eventKey")
                        
                        completion(true)
                    }
                }
            } else {
                print("Error!")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func deleteRequest(id: Int, completion: @escaping CompletionHandler) {
      
        let body: [String: Any] = [
            "request_id": id
        ]
        
        Alamofire.request(DELETE_REQUEST, method: .post,parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
            
            if response.result.error == nil {
                print(response.result)
                print("Success! Deleted Request")
                dump(response.result.value)
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["message"].string  == "Internal server error" {
                       completion(false)
                    }
                    else{
                       completion(true)
                    }
                }
            } else {
                print("Error!")
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
   
}
