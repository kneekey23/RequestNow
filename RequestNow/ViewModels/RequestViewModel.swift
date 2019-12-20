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

final class RequestViewModel: ObservableObject {
    
    var didChange = PassthroughSubject<RequestViewModel, Never>()
    
    @Published var eventId: String = ""
    
    @Published var eventKey: String = ""
    
    @Published var nameOfEvent: String = ""
    
    @Published var errorMessage: String = ""
    
    @Published var errorExists: Bool = false
    
    @Published private(set) var requests: [Request] = [] {
        didSet {
            didChange.send(self)
        }
    }
    @Published private(set) var requestsViewModels: [RequestCellViewModel] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published private(set) var state: RequestViewModelState = .loading
    
    private var eventIdCancellable: AnyCancellable?
    
    private var eventKeyCancellable: AnyCancellable?
    
    private var pushNotificationCancellable: AnyCancellable?
    
    private var getRequestsCancellable: AnyCancellable?
    
    private var deleteRequestCancellable: AnyCancellable?
    
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
            self.requests.append(notification.object as! Request)
            self.requestsViewModels.append(RequestCellViewModel(request: notification.object as! Request))
        }
    }
    
    func getRequests(with eventId: String?) {
        state = .loading
        getRequestsCancellable = requestService
            .getRequests(eventId: eventId)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error)
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] requestData in
                self?.requests = requestData.songRequests
                self?.requestsViewModels = requestData.songRequests.map {
                    RequestCellViewModel(request: $0)
                }
                self?.nameOfEvent = requestData.eventName
        }
    }
    
    func getEventId(with eventKey: String) {
        state = .loading
        eventIdCancellable = requestService
        .getEventId(eventKey: eventKey)
        .sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure(let error):
                self?.state = .error(error)
                self?.errorMessage = error.localizedDescription
                self?.errorExists = true
            case .finished: self?.state = .finishedLoading
            }
            
        }) { [weak self] eventId in
            self?.eventId = eventId
           
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
                    self?.errorExists = true
                case .finished: self?.state = .finishedLoading
                }
                
            }) { [weak self] success in
                
                if success {
                    self?.requestsViewModels.remove(at: index)
                }
                else{
                    self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                    self?.errorExists = true
                }
        }
    }
    
    func registerDeviceTokenForPushNotifications(with eventId: String) {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
            DispatchQueue.global(qos: .utility).async {
                self.requestService.registerDeviceToken(eventId: eventId, deviceToken: deviceToken)
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "eventId")
    }
}

final class RequestCellViewModel: ObservableObject, Hashable {

    
    @Published var time: String = ""
    @Published var songName: String = ""
    @Published var artist: String = ""
    @Published var originalMessage: String = ""
    @Published var id: Int = 0
    @Published var fromNumber: String = ""
    
    private let request: Request
    
    init(request: Request) {
        self.request = request
        setUpBindings()
    }
    
    func setUpBindings() {
        time = request.timeOfRequest.toTime()
        songName = request.songName ?? ""
        artist = request.artist ?? ""
        originalMessage = request.originalRequest
        id = request.id
        fromNumber = request.fromNumber
    }
}
