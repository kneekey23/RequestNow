//
//  Message.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

struct Message: Codable, Identifiable {
    
    public let id: Int
    public let originalRequest: String
    public let timeOfRequest: Date
    public let isFavorite: Bool
    public let fromNumber: String
    public let messageCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeOfRequest = "timestamp"
        case originalRequest = "original"
        case isFavorite = "starred"
        case fromNumber = "from_number"
        case messageCount = "message_count"
     
    }
}
