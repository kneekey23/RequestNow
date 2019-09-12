//
//  Date+Extension.swift
//  RequestNow
//
//  Created by Nicole Klein on 9/12/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import Foundation
extension Date {

    func toTime() -> String {

    let hour = Calendar.current.component(.hour, from: self)
    let minutes = Calendar.current.component(.minute, from: self)

    return "\(hour):\(minutes)"
    }
}
