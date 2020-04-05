//
//  AddEventViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 3/15/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class AddEventViewModel: ObservableObject {
    
    var objectWillChange = PassthroughSubject<Void,Never>()
    
    @Published var name: String = ""
    
    @Published var start: Date = Date() {
        willSet {
            startDateString = start.toShortDate()
            objectWillChange.send()
        }
    }
    
    @Published var end: Date = Date() {
        willSet {
            endDateString = end.toShortDate()
            objectWillChange.send()
        }
    }
    
    @Published var startDateString: String = ""
    
    @Published var endDateString: String = ""
    
    @Published var autoReplySignature: String = ""
    
    @Published var thankYouMessage: String = ""
    
    @Published var autoSongDetectionEnabled: Bool = false
    
    @Published var pushNotificationsEnabled: Bool = false
    
    @Published var guestNamesEnabled: Bool = false
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    
}
