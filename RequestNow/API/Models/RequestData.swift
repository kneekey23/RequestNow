//
//  Request.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

struct RequestData: Decodable {
    
    public let songRequests: [Request]
    public let eventName: String
    public let userId: Int
    public let messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case eventName = "eventName"
        case songRequests = "songRequests"
        case userId = "userId"
        case messages = "messages"
    }

    public init(nameOfEvent: String, requestList: [Request], userId: Int, messages: [Message]) {
        self.songRequests = requestList
        self.eventName = nameOfEvent
        self.userId = userId
        self.messages = messages
    }
    
}



