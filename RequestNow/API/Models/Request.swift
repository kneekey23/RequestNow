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

class Request: Codable {
    
    // Basic Trainer Info
    public let id: Int
    public let originalRequest: String
    public let artist: String
    public let songName: String
    public let timeOfRequest: String
    
    public init(id: Int, originalRequest: String, artist: String, songName: String, timeOfRequest: String){
        self.id = id
        self.originalRequest = originalRequest
        self.artist = artist
        self.songName = songName
        self.timeOfRequest = timeOfRequest
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case timeOfRequest = "time"
        case songName = "song"
        case artist = "artist"
        case originalRequest = "original"
    }
}



