//
//  Request.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

struct RequestData: Codable {
    
    public let songRequests: [Request]
    public let eventName: String
    public let userId: String
    public let messages: [Message]
    public let eventNumber: String
    public let eventActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case eventName = "eventName"
        case songRequests = "songRequests"
        case userId = "userId"
        case messages = "messages"
        case eventNumber = "eventNumber"
        case eventActive = "eventActive"
    }

    public init(nameOfEvent: String, requestList: [Request], userId: String, messages: [Message], eventNumber: String, eventActive: Bool) {
        self.songRequests = requestList
        self.eventName = nameOfEvent
        self.userId = userId
        self.messages = messages
        self.eventNumber = eventNumber
        self.eventActive = eventActive
    }
    
}



