//
//  EventCellViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation
import Combine

class EventCellViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var eventPhoneNumber: String = ""
    @Published var startDate: String = ""
    @Published var id: String = ""
    
    private let event: Event
    
    init(event: Event) {
        self.event = event
        setUpBindings()
    }
    
    func setUpBindings() {
        id = String(event.id)
        name = event.name
        eventPhoneNumber = event.phoneNumber
        startDate = event.startDate.toShortDate()
    }
}
