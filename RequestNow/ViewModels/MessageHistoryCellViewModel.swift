//
//  MessageHistoryCellViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine
import SwiftUI

final class MessageHistoryCellViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var fromDJ: Bool = false
    @Published var timeStamp: Date = Date()
    @Published var color: Color = ColorCodes.lighterShadeOfDarkGrey.color()
    @Published var id: UUID  = UUID()
    
    private let messageRequest: OriginalMessage
    
    init(originalRequest: OriginalMessage) {
        self.messageRequest = originalRequest
        setUpBindings()
    }
    
    func setUpBindings() {
        message = messageRequest.original
        fromDJ = messageRequest.fromDJ
        timeStamp = messageRequest.timeStamp
        id = messageRequest.id
        if fromDJ {
            color = ColorCodes.teal.color()
        }
    }
        
}
