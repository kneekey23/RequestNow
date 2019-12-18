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
    func getRequests(eventId: String?) -> AnyPublisher<[Request], Error>
}

final class RequestService: RequestServiceProtocol {
    
//    var defaults = UserDefaults.standard
//   // static let instance = RequestService()
//    @Published var requests: Requests
//    var nameOfEvent: String?
    
//    func getRequests(eventKey: Int, completion: @escaping CompletionHandler) {
//        Alamofire.request(EVENT_DATA + "?event_key=" + String(eventKey), method: .get, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
//
//            if response.result.error == nil {
//               // print(response.result)
//                print("Success! Got all requests")
//               // dump(response.result.value)
//
//                if let data = response.result.value {
//                    let json = JSON(data)
//                    if json["message"].string  == "Internal server error" {
//                        completion(false)
//                    }
//                    else{
//                        let requestResponse: Requests = data
//                        self.requests = requestResponse.requestList
//                        self.nameOfEvent = requestResponse.nameOfEvent
//                         UserDefaults.standard.set(eventKey, forKey: "eventKey")
//
//                        completion(true)
//                    }
//                }
//            } else {
//                print("Error!")
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//        }
//    }
    
    func getRequests(eventId: String?) -> AnyPublisher<[Request], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        
        // promise type is Result<[Player], Error>
        return Future<[Request], Error> { [weak self] promise in
            guard let eventId = eventId, let urlRequest = URL(string: EVENT_DATA + "?event_id=" + eventId) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let requests = try JSONDecoder().decode(Requests.self, from: data)
                    promise(.success(requests.requestList))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
//    func deleteRequest(id: Int, completion: @escaping CompletionHandler) {
//
//        let body: [String: Any] = [
//            "request_id": id
//        ]
//
//        Alamofire.request(DELETE_REQUEST, method: .post,parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseObject { (response: DataResponse<Requests>) in
//
//            if response.result.error == nil {
//                print(response.result)
//                print("Success! Deleted Request")
//                //dump(response.result.value)
//
//                if let data = response.result.value {
//                    let json = JSON(data)
//                    if json["message"].string  == "Internal server error" {
//                       completion(false)
//                    }
//                    else{
//                       completion(true)
//                    }
//                }
//            }
//            else {
//                print("Error!")
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//        }
//    }
    
//    func registerDeviceToken(eventKey: Int, deviceToken: String, completion: @escaping CompletionHandler) {
//
//        let body: [String: Any] = [
//            "device_id": deviceToken,
//            "event_id": eventKey
//        ]
//
//        Alamofire.request(REGISTER_TOKEN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON{(response) in
//
//            if response.result.error == nil {
//                print(response.result)
//                print("device registered!")
//                dump(response.result.value)
//            }
//            else {
//                print("Error!")
//            }
//
//        }
//    }
    
   
}
