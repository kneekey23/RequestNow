//
//  Request.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Requests: Mappable {
    
    // Basic Trainer Info
    var requestList: [Request]?
    var nameOfEvent: String?

    
    required init?(map: Map) {
        //
//        nameOfEvent = ""
//        requestList = []
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        nameOfEvent     <- map["NameOfEvent"]
        requestList     <- map["Requests"]
      //  requestList     <- map[Request(map: map["Requests"])]
        
    }
    
}



