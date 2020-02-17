//
//  Event.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//
import Foundation
import SwiftUI

class Event: Codable, Identifiable {
    
    public let id: Int
    public let name: String
    public let phoneNumber: String
    public let startDate: Date
    public let endDate: Date
    public let autoReplySignature: String
    public let thankYouMessage: String
    public let thankYouSent: Bool
    public let autoSongDetectionEnabled: Bool
    public let pushNotificationsEnabled: Bool
    public let guestNamesEnabled: Bool
    public let createdDate: Date
    public let modifiedDate: Date
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phoneNumber = "event_phone_number"
        case startDate = "start"
        case endDate = "end"
        case autoReplySignature = "auto_reply_signature"
        case thankYouMessage = "thank_you"
        case thankYouSent = "thank_you_sent"
        case autoSongDetectionEnabled = "auto_song_detection_enabled"
        case pushNotificationsEnabled = "push_notifications_enabled"
        case guestNamesEnabled = "guest_names_enabled"
        case createdDate = "created"
        case modifiedDate = "modstamp"
        
    }
    
}
