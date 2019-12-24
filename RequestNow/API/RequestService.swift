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
    case internalError(String)
}

protocol RequestServiceProtocol {
    func getRequests(eventId: String?) -> AnyPublisher<RequestData, Error>
    func getEventId(eventKey: String?) -> AnyPublisher<String, Error>
    func deleteRequest(id: Int) -> AnyPublisher<Bool, Error>
    func sendThankYouNote(eventId: String) -> AnyPublisher<Int, Error>
    func registerDeviceToken(eventId: String, deviceToken: String)
}

final class RequestService: RequestServiceProtocol {
    
    func getRequests(eventId: String?) -> AnyPublisher<RequestData, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
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
                    let formatter = DateFormatter.dateTimeFormat
                    decoder.dateDecodingStrategy = .formatted(formatter)
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
                        guard let eventId = dictionary["eventId"] as? Int else {
                            promise(.failure(ServiceError.internalError("Event Id not found")))
                            return
                        }
                        let eventIdString = String(eventId)
                        UserDefaults.standard.set(eventIdString, forKey: "eventId")
                        promise(.success(eventIdString))
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
    
    func deleteRequest(id: Int) -> AnyPublisher<Bool, Error> {
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<Bool, Error> { promise in
            
            let body: [String: Any] = [
                "request_id": String(id)
            ]
            
            guard let serviceUrl = URL(string: DELETE_REQUEST) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any] {
                        guard let success = dictionary["success"] as? Bool else {
                            promise(.failure(ServiceError.internalError(dictionary["message"] as? String ?? "Internal Server Error")))
                            return
                        }
                         promise(.success(success))
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
    
    func sendThankYouNote(eventId: String) -> AnyPublisher<Int, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<Int, Error> { promise in
            let body: [String: Any] = [
                "event_id": eventId
            ]
            
            guard let serviceUrl = URL(string: SEND_THANKYOU_NOTE) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                return
            }
            request.httpBody = httpBody
            print(request)
            dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any] {
                        guard let count = dictionary["partygoerCount"] as? Int else {
                            promise(.failure(ServiceError.internalError(dictionary["error"] as? String ?? "Internal Server Error")))
                            return
                        }
                         promise(.success(count))
                    }
                } catch {
                     promise(.failure(ServiceError.decode))
                }
            }
        }.receive(on: DispatchQueue.main)
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .eraseToAnyPublisher()
    }
    
    func registerDeviceToken(eventId: String, deviceToken: String) {

        let body = ["device_token": deviceToken,"event_id": eventId]
        guard let serviceUrl = URL(string: REGISTER_TOKEN) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
