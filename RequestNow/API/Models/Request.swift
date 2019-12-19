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
    
    public let id: Int
    public let originalRequest: String
    public let artist: String?
    public let songName: String?
    public let timeOfRequest: Date
    public let isFavorite: Bool
    public let fromNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeOfRequest = "timestamp"
        case songName = "song"
        case artist = "artist"
        case originalRequest = "original"
        case isFavorite = "starred"
        case fromNumber = "from_number"
     
    }
}



