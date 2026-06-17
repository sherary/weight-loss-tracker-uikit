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

internal struct Multiply {
    static let byOneHalf = 1.5
    static let byOneQuarter = 1.25
    static let byOneEighth = 1.125
    static let byHalf = 0.5
    static let byQuarter = 0.25
    static let byEighth = 0.125
    static let bySixteenth = 0.625
}
