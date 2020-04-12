//
//  User.swift
//  RequestNow
//
//  Created by Nicole Klein on 2/16/20.
//  Copyright © 2020 Confir Inc. All rights reserved.
//

import Foundation
import Auth0

class User: Codable {
    public let username: String
    public let userId: String
    public let accessToken: String
    
    init(username: String, userId: String, accessToken: String) {
        self.username = username
        self.userId = userId
        self.accessToken = accessToken
    }
    
    // MARK: - Singleton

    // 1
    private static var _current: User?

    // 2
    static var current: User? {
        // 3
        guard let currentUser = _current else {
           // fatalError("Error: current user doesn't exist")
            return nil
        }

        // 4
        return currentUser
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            if let data = try? JSONEncoder().encode(user) {
                // 4
                UserDefaults.standard.set(data, forKey: CURRENT_USER)
            }
        }

        _current = user
    }
    
    static func removeCurrent() {
        UserDefaults.standard.set(nil, forKey: CURRENT_USER)
    }
}
