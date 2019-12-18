//
//  UITextField+Publisher.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//
import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } // receiving notifications with objects which are instances of UITextFields
            .map { $0.text ?? "" } // mapping UITextField to extract text
            .eraseToAnyPublisher()
    }
}
