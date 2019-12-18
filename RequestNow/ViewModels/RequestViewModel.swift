//
//  RequestViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/17/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation
import Combine

enum RequestViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

final class RequestViewModel {
    @Published var eventId: String = ""
    
    @Published var eventKey: String = ""
    
    @Published var nameOfEvent: String = ""
    
    @Published private(set) var requestViewModels: [RequestCellViewModel] = []
    
    @Published private(set) var state: RequestViewModelState = .loading
    
    private var eventIdCancellable: AnyCancellable?
    
    private var eventKeyCancellable: AnyCancellable?
    
    private var pushNotificationCancellable: AnyCancellable?
    
    private let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService()) {
        self.requestService = requestService
        
        eventKeyCancellable = $eventKey.sink { [weak self] in
            self?.getEventId(with: $0)
        }
        
        eventIdCancellable = $eventId.sink { [weak self] in
            self?.getRequests(with: $0)
            self?.registerDeviceTokenForPushNotifications(with: $0)
        }
        
        pushNotificationCancellable = NotificationCenter.Publisher(center: .default,
                                                                   name: UPDATE_REQUESTS,
                                                                   object: nil)
        .sink { notification in
            self.requestViewModels.append(RequestCellViewModel(request: notification.object as! Request))
        }
    }
    
    func getRequests(with eventId: String?) {
        state = .loading
        _ = requestService
            .getRequests(eventId: eventId)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error): self?.state = .error(error)
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] requestData in
                self?.requestViewModels = requestData.requestList.map { RequestCellViewModel(request: $0) }
                self?.nameOfEvent = requestData.nameOfEvent
        }
    }
    
    func getEventId(with eventKey: String) {
        state = .loading
        _ = requestService
        .getEventId(eventKey: eventKey)
        .sink(receiveCompletion: { [weak self] (completion) in
            switch completion {
            case .failure(let error): self?.state = .error(error)
            case .finished: self?.state = .finishedLoading
            }
            
        }) { [weak self] eventId in
            self?.eventId = eventId
        }
    }
    
    func registerDeviceTokenForPushNotifications(with eventId: String) {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
            DispatchQueue.global(qos: .utility).async {
                self.requestService.registerDeviceToken(eventId: eventId, deviceToken: deviceToken)
            }
        }
    }
}

final class RequestCellViewModel {
    @Published var time: String = ""
    @Published var songName: String = ""
    @Published var artist: String = ""
    @Published var originalMessage: String = ""
    
    private let request: Request
    
    init(request: Request) {
        self.request = request
        setUpBindings()
    }
    
    func setUpBindings() {
        time = request.timeOfRequest
        songName = request.songName
        artist = request.artist
        originalMessage = request.originalRequest
    }
}
