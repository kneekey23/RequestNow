//
//  RequestCellViewModel.swift
//  RequestNow
//
//  Created by Nicole Klein on 1/1/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Combine
import SwiftUI

final class RequestCellViewModel: ObservableObject {

    @Published var time: String = ""
    @Published var songName: String = ""
    @Published var artist: String = ""
    @Published var originalMessages: [String] = []
    @Published var count: String = ""
    @Published var id: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var activeAlert: ActiveAlert = .error
    
    private var informUpNextCancellable: AnyCancellable?
    private let requestService: RequestServiceProtocol
    private let request: Request
    
    init(request: Request, requestService: RequestServiceProtocol = RequestService()) {
        self.request = request
        self.requestService = requestService
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
    
    func informUpNext() {
        informUpNextCancellable = requestService
        .informUpNext(groupId: id)
            .sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let serviceError):
                    if let errorCasted = serviceError as? ServiceError {
                        self?.unWrapError(error: errorCasted)
                        self?.showAlert = true
                    }
                case .finished: break
                }
            }) { [weak self] success in
                
                if success {
                    self?.showAlert = true
                    self?.errorMessage = ""
                    self?.activeAlert = .success
                    self?.successMessage = "You let everyone know that " + self!.songName + " will be played next."
                }
                else{
                    self?.activeAlert = .error
                    self?.errorMessage = "Request could not be completed for some unknown reason. Please contact support."
                    self?.showAlert = true
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
