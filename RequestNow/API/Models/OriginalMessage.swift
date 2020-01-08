//
//  OriginalRequest.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/30/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation

struct OriginalMessage: Codable, Identifiable {
    
    public let id: UUID = UUID()
    public let timeStamp: Date
    public let original: String
    public let fromDJ: Bool
    public let name: String?
    
    init(timeStamp: Date, original: String, fromDJ: Bool, name: String) {
        self.timeStamp = timeStamp
        self.original = original
        self.fromDJ = fromDJ
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case timeStamp = "timestamp"
        case original = "original"
        case fromDJ = "fromDj"
        case name = "name"
    }
}
