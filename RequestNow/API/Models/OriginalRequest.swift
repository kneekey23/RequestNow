//
//  OriginalRequest.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/5/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation

struct OriginalRequest: Codable, Identifiable {
    
    public let id: UUID = UUID()
    public let original: String
    public let name: String?
    
    init(original: String, name: String) {
        self.original = original
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case original = "original"
    }
}
