//
//  EventService.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation
import Combine

protocol EventServiceProtocol {
    func getEvents() -> AnyPublisher<[Event], Error>
}

final class EventService: EventServiceProtocol {
    
    func getEvents() -> AnyPublisher<[Event], Error> {
        guard let currentUser = User.current else {
            return Future<[Event], Error> { promise in
                promise(.failure(ServiceError.internalError("No user signed in")))
                return
            }.eraseToAnyPublisher()
        }
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        return Future<[Event], Error> { promise in
            
            guard let url = URL(string: EVENTS) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 10.0
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer " + currentUser.accessToken
               // "x-api-key": API_KEY
            ]
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let formatter = DateFormatter.dateTimeFormat
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let events = try decoder.decode([Event].self, from: data)
                    promise(.success(events))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .eraseToAnyPublisher()
    }
}
