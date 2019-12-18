//
//  Request.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

struct RequestData: Codable {
    
    public let requestList: [Request]
    public let nameOfEvent: String
    
    enum CodingKeys: String, CodingKey {
        case nameOfEvent = "NameOfEvent"
        case requestList = "Requests"
    }

    public init(nameOfEvent: String, requestList: [Request]) {
        self.requestList = requestList
        self.nameOfEvent = nameOfEvent
    }
    
}



