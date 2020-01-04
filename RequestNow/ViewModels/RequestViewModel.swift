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

enum SortBy: String {
    case recency = "recency"
    case popularity = "popularity"
}

final class RequestViewModel: ObservableObject {
    
    var didChange = PassthroughSubject<RequestViewModel, Never>()
    
    @Published var eventId: String = ""
    
    @Published var eventKey: String = ""
    
    @Published var nameOfEvent: String = ""
    
    @Published var eventNumber: String = ""
    
    @Published var errorMessage: String = ""
    
    @Published var successMessage: String = ""
    
    @Published var eventStatus: String = "Inactive"
    
    @Published var showAlert: Bool = false
    
    @Published var activeAlert: ActiveAlert = .error
    
    @Published var isShowingRefresh: Bool = false
    
    @Published var sortSelection: SortBy = .recency
    
    @Published private(set) var requestsViewModels: [RequestCellViewModel] = []
    
    @Published private(set) var messageViewModels: [MessageCellViewModel] = []
    
    @Published private(set) var state: RequestViewModelState = .loading
    
    private var eventIdCancellable: AnyCancellable?
    
    private var sortByCancellable: AnyCancellable?
    
    private var eventKeyCancellable: AnyCancellable?
    
    private var pushNotificationCancellable: AnyCancellable?
    
    private var getRequestsCancellable: AnyCancellable?
    
    private var deleteRequestCancellable: AnyCancellable?
    
    private var thankYouNoteRequestCancellable: AnyCancellable?
    
    private var logoutCancellable: AnyCancellable?
    
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
            self?.getRequests(with: $0, sortSelection: self?.sortSelection ?? .recency)
            self?.registerDeviceTokenForPushNotifications(with: $0)
        }
        
        sortByCancellable = $sortSelection.sink { [weak self] in
            self?.getRequests(with: self?.eventId, sortSelection: $0)
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
    
    func getRequests(with eventId: String?, sortSelection: SortBy) {
        state = .loading
        if let eventId = eventId, eventId.isEmpty {
            return
        }
        getRequestsCancellable = requestService
            .getRequests(eventId: eventId, sortKey: sortSelection.rawValue)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let serviceError):
                    if let errorCasted = serviceError as? ServiceError {
                    self?.unWrapError(error: errorCasted)
                    self?.state = .error(serviceError)
                    }
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
            case .failure(let serviceError):
                let errorCasted = serviceError as! ServiceError
                self?.unWrapError(error: errorCasted)
                self?.state = .error(serviceError)
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
                case .failure(let serviceError):
                    let errorCasted = serviceError as! ServiceError
                    self?.unWrapError(error: errorCasted)
                    self?.state = .error(serviceError)
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
            case .failure(let serviceError):
                let errorCasted = serviceError as! ServiceError
                self?.unWrapError(error: errorCasted)
                self?.state = .error(serviceError)
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
    
    func logout(completedLogout: @escaping (Bool) -> Void) {
        state = .loading
        
        logoutCancellable = requestService
            .logout(eventId: eventId)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let serviceError):
                    let errorCasted = serviceError as! ServiceError
                    self?.unWrapError(error: errorCasted)
                    self?.state = .error(serviceError)
                    self?.showAlert = true
                  
                case .finished: self?.state = .finishedLoading
                }
            }) { [weak self] success in
                
                if success {
                    self?.errorMessage = ""
                     UserDefaults.standard.removeObject(forKey: "eventId")
                    completedLogout(true)
                }
                else{
                    self?.activeAlert = .error
                    self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                    self?.showAlert = true
                    completedLogout(false)
                }
        }
    }
    
    func openSupport(){
        LiveChat.presentChat()
    }
    
    func registerDeviceTokenForPushNotifications(with eventId: String) {
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken") {
             DispatchQueue.once(executionToken: "registerDeviceToken") {
                self.requestService.registerDeviceToken(eventId: eventId, deviceToken: deviceToken)
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






