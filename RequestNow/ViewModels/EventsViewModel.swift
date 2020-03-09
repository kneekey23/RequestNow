//
//  EventsViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine

enum EventViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}

class EventsViewModel: ObservableObject {
    
    @Published private(set) var eventViewModels: [EventCellViewModel] = []
    
    @Published private(set) var state: EventViewModelState = .loading
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var showAddEventModal: Bool = false
    
    private var getEventsCancellable: AnyCancellable?
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
        getEvents()
    }
    
    func getEvents() {
        state = .loading

        getEventsCancellable = eventService
            .getEvents()
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let serviceError):
                    if let errorCasted = serviceError as? ServiceError {
                    self?.unWrapError(error: errorCasted)
                    self?.state = .error(serviceError)
                    self?.showAlert = true
                    }
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] events in
                self?.eventViewModels = events.map {
                    EventCellViewModel(event: $0)
                }
        }
    }
    
    func unWrapError(error: ServiceError) {
        switch error {
        case .url:
            self.errorMessage = "There was something wrong with the url request, please contact support."
        case .urlRequest:
             self.errorMessage = "There was something wrong with the url request, please contact support."
        case .decode:
             self.errorMessage = "There was something wrong with the response. Please make sure you are on the latest version of the app or contact support."
        case .internalError(let errorString):
             self.errorMessage = errorString
        }
    }
}
