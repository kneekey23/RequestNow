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

    
    func logIn() {         
         Auth0
         .authentication()
         .login(
             usernameOrEmail: username,
             password: password,
             realm: "Username-Password-Authentication",
             audience: "https://api.requestnow.io",
             scope: "openid profile email")
          .start { result in
              switch result {
              case .success(let credentials):
                 print("Obtained credentials: \(credentials)")
                 if let accessToken = credentials.accessToken,
                    let idToken = credentials.idToken {
                    let user = User(username: self.username, userId: idToken, accessToken: accessToken)
                    User.setCurrent(user, writeToUserDefaults: true)
                 }
                 DispatchQueue.main.async {
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
        self.username = ""
        self.password = ""
        self.errorMessage = ""
        self.isLoggedIn = false
        User.removeCurrent()
    }
}
