//
//  OriginalRequest.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/30/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation

struct OriginalRequest: Codable, Identifiable {
    
    public let id: UUID = UUID()
    public let timeStamp: Date
    public let original: String
    public let fromDJ: Bool
    
    init(timeStamp: Date, original: String, fromDJ: Bool) {
        self.timeStamp = timeStamp
        self.original = original
        self.fromDJ = fromDJ
    }
    
    enum CodingKeys: String, CodingKey {
        case timeStamp = "timestamp"
        case original = "original"
        case fromDJ = "fromDj"
    }
}
