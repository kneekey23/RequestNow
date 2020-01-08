//
//  Message.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

struct Message: Codable, Identifiable {
    
    public let id: String
    public let originalRequests: [OriginalMessage]
    public let timeOfRequest: Date
    public let messageCount: String
    
    enum CodingKeys: String, CodingKey {
        case id = "groupId"
        case timeOfRequest = "timestamp"
        case originalRequests = "originals"
        case messageCount = "count"
     
    }
}
