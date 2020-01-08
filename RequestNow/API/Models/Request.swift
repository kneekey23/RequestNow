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
    
    
    public let id: String
    public let count: String
    public let originalRequests: [OriginalRequest]
    public let artist: String?
    public let songName: String?
    public let timeOfRequest: Date
    
    enum CodingKeys: String, CodingKey {
  
        case timeOfRequest = "timestamp"
        case songName = "song"
        case artist = "artist"
        case originalRequests = "originals"
        case count = "count"
        case id = "groupId"
     
    }
    
    @discardableResult
    static func makeRequestGroup(_ notification: [String: AnyObject]) -> Request? {
        guard let request = notification["songRequest"] as? [String: AnyObject],
        let jsonData = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
        else {
            return nil
        }
        let decoder = JSONDecoder()
        let formatter = DateFormatter.dateTimeFormat
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let newRequest = try! decoder.decode(Request.self, from: jsonData)
        
        NotificationCenter.default.post(
            name: UPDATE_REQUESTS,
            object: newRequest)
        
        return newRequest
    }
}



