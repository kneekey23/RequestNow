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

class Request: Mappable {
    
    // Basic Trainer Info
    var id: String?
    var originalRequest: String?
    var artist: String?
    var songName: String?
    var timeOfRequest: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        id              <- map["id"]
        timeOfRequest   <- map["time"]
        songName        <- map["song"]
        artist          <- map["artist"]
        originalRequest <- map["original"]
        
    }
    
}



