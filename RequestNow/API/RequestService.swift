//
//  RequestService.swift
//  RequestNow
//
//  Created by Nicole Klein on 9/12/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}


protocol RequestServiceProtocol {
    func getRequests(eventId: String?) -> AnyPublisher<RequestData, Error>
    func getEventId(eventKey: String?) -> AnyPublisher<String, Error>
    func registerDeviceToken(eventId: String, deviceToken: String)
}

final class RequestService: RequestServiceProtocol {
    
    var defaults = UserDefaults.standard
    func getRequests(eventId: String?) -> AnyPublisher<RequestData, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<RequestData, Error> { promise in
            guard let eventId = eventId, let url = URL(string: EVENT_DATA + "?event_id=" + eventId) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 10.0
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                   // decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let requests = try decoder.decode(RequestData.self, from: data)
                    promise(.success(requests))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .eraseToAnyPublisher()
    }
    
    func getEventId(eventKey: String?) -> AnyPublisher<String, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<String, Error> { promise in
            guard let eventKey = eventKey, let url = URL(string: EVENT_ID + "?event_code=" + eventKey) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 10.0
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { data, _,error in
                
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any] {
                        if let eventId = dictionary["eventId"] as? Int {
                            let eventIdString = String(eventId)
                            UserDefaults.standard.set(eventIdString, forKey: "eventId")
                            promise(.success(eventIdString))
                        }
                    }
                } catch {
                    promise(.failure(ServiceError.decode))
                }
                
            }
        }
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .eraseToAnyPublisher()
    }
    
    func deleteRequest(id: Int) {

        let body: [String: Any] = [
            "request_id": id
        ]
        guard let serviceUrl = URL(string: DELETE_REQUEST) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func registerDeviceToken(eventId: String, deviceToken: String) {

        let body = ["device_id": deviceToken,"event_id": eventId]
        guard let serviceUrl = URL(string: REGISTER_TOKEN) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
   
}
