//
//  RequestViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/17/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI
import Combine

enum RequestViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

enum ActiveAlert {
    case error, success
}

final class RequestViewModel: ObservableObject {
    
    var didChange = PassthroughSubject<RequestViewModel, Never>()
    
    @Published var eventId: String = ""
    
    @Published var eventKey: String = ""
    
    @Published var nameOfEvent: String = ""
    
    @Published var eventNumber: String = ""
    
    @Published var errorMessage: String = ""
    
    @Published var successMessage: String = ""
    
    @Published var eventStatus: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var activeAlert: ActiveAlert = .error
    
    @Published var isShowingRefresh: Bool = false
    
    @Published private(set) var requestsViewModels: [RequestCellViewModel] = []
    
    @Published private(set) var messageViewModels: [MessageCellViewModel] = []
    
    @Published private(set) var state: RequestViewModelState = .loading
    
    private var eventIdCancellable: AnyCancellable?
    
    private var eventKeyCancellable: AnyCancellable?
    
    private var pushNotificationCancellable: AnyCancellable?
    
    private var getRequestsCancellable: AnyCancellable?
    
    private var deleteRequestCancellable: AnyCancellable?
    
    private var thankYouNoteRequestCancellable: AnyCancellable?
    
    private let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService()) {
        self.requestService = requestService
        eventId = UserDefaults.standard.string(forKey: "eventId") ?? ""
        eventKeyCancellable = $eventKey.sink { [weak self] in
            if $0.count == 4 {
            self?.getEventId(with: $0)
            }
        }
        
        eventIdCancellable = $eventId.sink { [weak self] in
            self?.getRequests(with: $0)
            self?.registerDeviceTokenForPushNotifications(with: $0)
        }
        
        pushNotificationCancellable = NotificationCenter.Publisher(center: .default,
                                                                   name: UPDATE_REQUESTS,
                                                                   object: nil)
        .sink { notification in
           
            let requestCellViewModel = RequestCellViewModel(request: notification.object as! Request)
            if self.requestsViewModels.contains(where: {$0.id == requestCellViewModel.id}) {
                if let index = self.requestsViewModels.firstIndex(where: {$0.id == requestCellViewModel.id}) {
                self.requestsViewModels[index] = requestCellViewModel
                }
            }
            else {
                self.requestsViewModels.append(requestCellViewModel)
            }
            
        }
    }
    
    func getRequests(with eventId: String?) {
        state = .loading
        getRequestsCancellable = requestService
            .getRequests(eventId: eventId, sortKey: "recency")
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error)
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] requestData in
               
                self?.requestsViewModels = requestData.songRequests.map {
                    RequestCellViewModel(request: $0)
                }
                self?.messageViewModels = requestData.messages.map {
                    MessageCellViewModel(message: $0)
                }
                self?.nameOfEvent = requestData.eventName
                self?.eventNumber = requestData.eventNumber.formattedNumber()
                self?.eventStatus = requestData.eventActive ? "Active" : "Inactive"
                if let viewModel = self {
                    if viewModel.isShowingRefresh {
                        viewModel.isShowingRefresh.toggle()
                    }
                }

        }
    }
    
    func getEventId(with eventKey: String) {
        state = .loading
        eventIdCancellable = requestService
        .getEventId(eventKey: eventKey.lowercased())
        .sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
            case .finished: self?.state = .finishedLoading
            }
            
        }) { [weak self] eventId in
            self?.eventId = eventId
            self?.errorMessage = ""
           
        }
    }
    
    func deleteRequest(index: Int) {
        state = .loading
        let id = self.requestsViewModels[index].id
        deleteRequestCancellable = requestService
            .deleteRequest(id: id)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    
                    
                    self?.state = .error(error)
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] success in
                
                if success {
                    self?.requestsViewModels.remove(at: index)
                    self?.errorMessage = ""
                }
                else{
                    self?.activeAlert = .error
                    self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                    self?.showAlert = true
                }
        }
    }
    
    func sendThankYouNote() {
        state  = .loading
        thankYouNoteRequestCancellable = requestService
        .sendThankYouNote(eventId: eventId)
        .sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
                self?.errorMessage = error.localizedDescription
                self?.showAlert = true
                self?.successMessage = ""
            case .finished: self?.state = .finishedLoading
            }
        }) { [weak self] count in
            
            if let countInt = Int(count), countInt > 0 {
                self?.activeAlert = .success
                self?.showAlert = true
                self?.successMessage = "Thank you message was sent to " + String(count) + " guests."
                self?.errorMessage = ""
            }
            else {
                self?.activeAlert = .error
                self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                self?.showAlert = true
            }
        }
    }
    

    
    func registerDeviceTokenForPushNotifications(with eventId: String) {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
             DispatchQueue.once(executionToken: "registerDeviceToken") {
                self.requestService.registerDeviceToken(eventId: eventId, deviceToken: deviceToken)
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "eventId")
    }
}

final class RequestCellViewModel: ObservableObject {

    @Published var time: String = ""
    @Published var songName: String = ""
    @Published var artist: String = ""
    @Published var originalMessages: [String] = []
    @Published var count: String = ""
    @Published var id: String = ""
   
    private let request: Request
    
    init(request: Request) {
        self.request = request
        setUpBindings()
    }
    
    func setUpBindings() {
        time = request.timeOfRequest.toTime()
        songName = request.songName ?? ""
        artist = request.artist ?? ""
        originalMessages = request.originalRequests
        count = request.count
        id = request.id
    }
}

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

final class MessageHistoryCellViewModel: ObservableObject {
    @Published var message: String = ""
    @Published var fromDJ: Bool = false
    @Published var timeStamp: Date = Date()
    @Published var color: Color = ColorCodes.lighterShadeOfDarkGrey.color()
    @Published var id: UUID  = UUID()
    
    private let messageRequest: OriginalRequest
    
    init(originalRequest: OriginalRequest) {
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
