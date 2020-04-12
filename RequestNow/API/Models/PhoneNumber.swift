//
//  PhoneNumber.swift
//  RequestNow
//
//  Created by Nicole Klein on 4/11/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation

struct PhoneNumber: Codable {
    
    public let id: String
    public let description: String
    public let phoneNumber: String
    public let region: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "description"
        case phoneNumber = "phone_number"
        case region = "region"
    }
}
