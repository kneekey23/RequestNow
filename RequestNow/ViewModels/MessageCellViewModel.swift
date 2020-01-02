//
//  MessageCellViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine
import SwiftUI

final class MessageCellViewModel: ObservableObject {
    
    @Published var time: String = ""
    @Published var originalMessages: [String] = []
    @Published var messageCount: String = ""
    @Published var id: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var messages: [MessageHistoryCellViewModel] = []
    @Published var composedMessage: String = ""
    private var replyRequestCancellable: AnyCancellable?
    private let message: Message
    private let requestService: RequestServiceProtocol
    init(message: Message, requestService: RequestServiceProtocol = RequestService()) {
        self.message = message
        self.requestService = requestService
        setUpBindings()
    }
    
    func setUpBindings() {
        time = message.timeOfRequest.toTime()
        originalMessages = message.originalRequests.map({$0.original})
        let sortedMessages = message.originalRequests.sorted(by: {$0.timeStamp.compare($1.timeStamp) == .orderedAscending})
        messages = sortedMessages.map {
            MessageHistoryCellViewModel(originalRequest: $0)
        }
        messageCount = String(message.messageCount)
        id = message.id
    }
    
    func replyToRequest() {
     
        replyRequestCancellable = requestService
        .replyToRequest(groupId: id, reply: composedMessage)
        .sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure:
                self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                self?.showAlert = true
            case .finished: print("finished")
            }
            
        }) { [weak self] success in
            
            if success {
                self?.messages.append(MessageHistoryCellViewModel(originalRequest: OriginalRequest(timeStamp: Date(), original: self?.composedMessage ?? "", fromDJ: true)))
                self?.composedMessage = ""
            }
            else {

            }
            
        }
    }
}
