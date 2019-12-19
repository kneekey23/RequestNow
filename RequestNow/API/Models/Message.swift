//
//  Message.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit

class Message: Codable, Identifiable {
    
    // Basic Trainer Info
    public let id: Int
    public let originalRequest: String
    public let timeOfRequest: Date
    public let isFavorite: Bool
    public let fromNumber: String
    public let messageCount: Int
    
    public init(id: Int,
                originalRequest: String,
                timeOfRequest: Date,
                isFavorite: Bool,
                fromNumber: String,
                messageCount: Int){
        self.id = id
        self.originalRequest = originalRequest
        self.timeOfRequest = timeOfRequest
        self.isFavorite = isFavorite
        self.fromNumber = fromNumber
        self.messageCount = messageCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeOfRequest = "timestamp"
        case originalRequest = "original"
        case isFavorite = "starred"
        case fromNumber = "from_number"
        case messageCount = "message_count"
     
    }
}
