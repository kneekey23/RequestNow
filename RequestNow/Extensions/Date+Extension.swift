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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let time = dateFormatter.string(from: self)
        return time
    }
}

extension DateFormatter {
  static let dateTimeFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
   // formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
   // formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
