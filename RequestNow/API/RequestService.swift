//
//  RequestService.swift
//  RequestNow
//
//  Created by Nicole Klein on 9/12/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation
import Combine
import Auth0

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
    case internalError(String)
}

protocol RequestServiceProtocol {
    func getRequests(eventId: String?, sortKey: String) -> AnyPublisher<RequestData, Error>
    func getEventId(eventKey: String?) -> AnyPublisher<String, Error>
    func deleteRequest(id: String) -> AnyPublisher<Bool, Error>
    func sendThankYouNote(eventId: String) -> AnyPublisher<String, Error>
    func registerDeviceToken(eventId: String, deviceToken: String)
    func replyToRequest(groupId: String, reply: String) -> AnyPublisher<OriginalMessage, Error>
    func informUpNext(groupId: String) -> AnyPublisher<Bool, Error>
    func runRaffle(eventId: String) -> AnyPublisher<String, Error>
}

final class RequestService: RequestServiceProtocol {
    
    func getRequests(eventId: String?, sortKey: String) -> AnyPublisher<RequestData, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<RequestData, Error> { promise in
            guard let eventId = eventId, let url = URL(string: EVENT_DATA + "?event_id=" + eventId + "&song_request_groups_sort_key=" + sortKey) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 10.0
            urlRequest.httpMethod = "GET"
            urlRequest.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json"
               // "x-api-key": API_KEY
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
                "Accept": "application/json",
                "x-api-key": API_KEY
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
                        guard let eventId = dictionary["eventId"] as? String else {
                            promise(.failure(ServiceError.internalError("Event Id not found")))
                            return
                        }
                        UserDefaults.standard.set(eventId, forKey: "eventId")
                        promise(.success(eventId))
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
    
    func deleteRequest(id: String) -> AnyPublisher<Bool, Error> {
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<Bool, Error> { promise in
            
            let body: [String: Any] = [
                "group_id": id
            ]
            
            guard let serviceUrl = URL(string: DELETE_REQUEST) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
            
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
    
    func sendThankYouNote(eventId: String) -> AnyPublisher<String, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<String, Error> { promise in
            let body: [String: Any] = [
                "event_id": eventId
            ]
            
            guard let serviceUrl = URL(string: SEND_THANKYOU_NOTE) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
            
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
                        guard let count = dictionary["partygoerCount"] as? String else {
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

        let body = ["device_token": deviceToken,"event_id": eventId, "platform": "IOS"]
        guard let serviceUrl = URL(string: REGISTER_TOKEN) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
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
    
    func replyToRequest(groupId: String, reply: String) -> AnyPublisher<OriginalMessage, Error>  {

         var dataTask: URLSessionDataTask?
         
         let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
         let onCancel: () -> Void = { dataTask?.cancel() }
         
         return Future<OriginalMessage, Error> { promise in
             let body: [String: Any] = [
                 "group_id": groupId,
                 "reply": reply
             ]
             
             guard let serviceUrl = URL(string: REPLY_REQUEST) else { return }
             
             var request = URLRequest(url: serviceUrl)
             request.httpMethod = "POST"
             request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             request.setValue("application/json", forHTTPHeaderField: "Accept")
             request.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
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
                      let decoder = JSONDecoder()
                      let formatter = DateFormatter.dateTimeFormat
                      decoder.dateDecodingStrategy = .formatted(formatter)
                      let request = try decoder.decode(OriginalMessage.self, from: data)
                      promise(.success(request))
                 } catch {
                      promise(.failure(ServiceError.decode))
                 }
             }
         }.receive(on: DispatchQueue.main)
         .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
         .eraseToAnyPublisher()
     }
    
    func informUpNext(groupId: String) -> AnyPublisher<Bool, Error> {
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<Bool, Error> { promise in
            
            let body: [String: Any] = [
                "group_id": groupId
            ]
            
            guard let serviceUrl = URL(string: INFORM_UP_NEXT) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(API_KEY, forHTTPHeaderField: "x-api-key")
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
                            promise(.failure(ServiceError.internalError(dictionary["error"] as? String ?? "Internal Server Error")))
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
    
    func runRaffle(eventId: String) -> AnyPublisher<String, Error> {
        
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        return Future<String, Error> { promise in
            
            
            guard let serviceUrl = URL(string: GET_RAFFLE_WINNER + "?event_id=" + eventId) else { return }
            
            var request = URLRequest(url: serviceUrl)
            request.timeoutInterval = 10.0
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "x-api-key": API_KEY
            ]
            
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
                        guard let success = dictionary["winnerLineNumber"] as? String else {
                            promise(.failure(ServiceError.internalError(dictionary["error"] as? String ?? "Internal Server Error")))
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
}
