//
//  AuthAccess.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/15/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation
import Combine
import Auth0

class AuthAccess: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    @Published var username: String = ""
    
    @Published var password: String = ""
    
    @Published var errorMessage: String = ""
    
    private var loginCancellable: AnyCancellable?
    
    private var logoutCancellable: AnyCancellable?
    
    var credentials: Credentials?
    
    private let requestService: RequestServiceProtocol
    
    init(requestService: RequestServiceProtocol = RequestService()) {
        self.requestService = requestService
    }
    
    func logIn() {         
         Auth0
         .authentication()
         .login(
             usernameOrEmail: username,
             password: password,
             realm: "Username-Password-Authentication",
             scope: "openid")
          .start { result in
              switch result {
              case .success(let credentials):
                 print("Obtained credentials: \(credentials)")
                 DispatchQueue.main.async {
                    self.credentials = credentials
                    self.isLoggedIn = true
                 }
                
              case .failure(let error):
                 print("Failed with \(error)")
                 DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                 }
              }
          }
            
             
         
     }
    
    func signUp() {
        Auth0
        .webAuth()
        .audience("https://requestnow-v3.auth0.com/userinfo")
        .start { result in
            switch result { // Auth0.Result
            case .success(let credentials):
                print("credentials: \(credentials)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func logout() {
        self.credentials = nil
        self.username = ""
        self.password = ""
        self.errorMessage = ""
        self.isLoggedIn = false
    }
}
