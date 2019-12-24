//
//  DispatchQueue+Extension.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/22/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation

extension DispatchQueue {

    private static var tokens: [String] = [] // static, so tokens are cached

    class func once(executionToken: String, _ closure: () -> Void) {
        // objc_sync_enter/objc_sync_exit is a locking mechanism
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        // if we previously stored token then do nothing
        if tokens.contains(executionToken) { return }
        tokens.append(executionToken)
        closure()
    }
}
