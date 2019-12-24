//
//  Request.swift
//  RequestNow
//
//  Created by Nicole Klein on 7/8/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import UIKit
import Foundation

struct Request: Codable, Identifiable {
    
    
    public let id: UUID = UUID()
    public let count: String
    public let originalRequests: [String]
    public let artist: String?
    public let songName: String?
    public let timeOfRequest: Date
    public let isFavorite: Bool
    public let fromNumber: String
    
    enum CodingKeys: String, CodingKey {
  
        case timeOfRequest = "timestamp"
        case songName = "song"
        case artist = "artist"
        case originalRequests = "originals"
        case isFavorite = "starred"
        case fromNumber = "fromNumber"
        case count = "count"
     
    }
}



