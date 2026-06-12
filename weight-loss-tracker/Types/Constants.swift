//
//  Constants.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 19/05/26.
//

import CoreFoundation
import UIKit

internal enum Sex: String, Codable {
    case MALE = "M"
    case FEMALE = "F"
}

internal enum ActivityLevels: Double, Codable {
    case SEDENTARY = 1.2
    case LIGHT = 1.375
    case MODERATE = 1.55
    case VERY_ACTIVE = 1.725
    case SUPER_ACTIVE = 1.9
}

internal struct BorderStyles {
    static let CLASSIC: [NSNumber] = [4, 2]
    static let DOTTED: [NSNumber] = [1, 3]
    static let DOTTED_DASH: [NSNumber] = [8, 4, 2, 4]
}

internal struct ViewActivity {
    static let add: String = "add"
    static let update: String = "edit"
}
