//
//  ColorCodes.swift
//  RequestNow
//
//  Created by Nicole Klein on 12/18/19.
//  Copyright © 2019 Confir Inc. All rights reserved.
//

import SwiftUI
import UIKit

enum ColorCodes {
    case darkGrey
    case teal
    case pastelRed
    case lightGrey
    case lighterShadeOfDarkGrey
    case requestGrey
}

extension ColorCodes {
    func color() -> Color {
        switch self {
        case .darkGrey: return Color(red: 41/255, green:47/255, blue: 54/255)
        case .teal: return Color(red:71/255, green: 187/255, blue: 179/255)
        case .pastelRed: return Color(red: 255/255, green: 107/255, blue: 107/255)
        case .lightGrey: return Color(red: 163/255, green: 163/255, blue: 163/255)
        case .lighterShadeOfDarkGrey: return Color(red: 72/255, green: 76/255, blue: 81/255)
        case .requestGrey: return Color(red: 60/255, green: 65/255, blue: 72/255)
        }
    }
    
    func uicolor() -> UIColor {
        switch self {
        case .darkGrey: return UIColor(red: 41/255, green: 47/255, blue: 54/255, alpha: 1.0)
        case .teal: return UIColor(red: 71/255, green: 187/255, blue: 179/255, alpha: 1.0)
        case .pastelRed: return UIColor(red: 255/255, green: 107/255, blue: 107/255, alpha: 1.0)
        case .lightGrey: return UIColor(red: 163/255, green: 163/255, blue: 163/255, alpha: 1.0)
        case .lighterShadeOfDarkGrey: return UIColor(red: 72/255, green: 76/255, blue: 81/255, alpha: 1.0)
        case .requestGrey: return UIColor(red: 60/255, green: 65/255, blue: 72/255, alpha: 1.0)
        }
    }
}
