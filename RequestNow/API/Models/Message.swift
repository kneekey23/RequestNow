//
//  Message.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

struct Message: Codable, Identifiable {
    
    public let id: UUID = UUID()
    public let originalRequests: [String]
    public let timeOfRequest: Date
    public let fromNumber: String
    public let messageCount: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeOfRequest = "timestamp"
        case originalRequests = "originals"
        case fromNumber = "fromNumber"
        case messageCount = "messageCount"
     
    }
}
