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
    
    @Published private(set) var requestViewModels: [RequestCellViewModel] = []
    
    @Published private(set) var state: RequestViewModelState = .loading
    
    private var eventIdCancellable: AnyCancellable?
    
    private let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService()) {
        self.requestService = requestService
        
        eventIdCancellable = $eventId.sink { [weak self] in
            self?.getRequests(with: $0)
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
            }) { [weak self] requests in
                self?.requestViewModels = requests.map { RequestCellViewModel(request: $0) }
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
