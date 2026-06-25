//
//  Constants.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 19/05/26.
//

import CoreFoundation
import UIKit

internal enum Sex: String, CustomStringConvertible {
    case male = "M"
    case female = "F"
    
    var description: String {
        return self.rawValue
    }
}

internal enum ActivityLevels: Double, Codable, CaseIterable {
    case sedentary = 1.2
    case lightActivity = 1.375
    case moderateActivity = 1.55
    case veryActive = 1.725
    case athletic = 1.9
    
    var name: String {
        switch self {
        case .sedentary: 
            return "Sedentary"
        case .lightActivity: 
            return "Light Activity"
        case .moderateActivity:
            return "Moderate Activity"
        case .veryActive:
            return "Very Active"
        case .athletic:
            return "Athletic"
        }
    }
}

internal enum MeasurementUnits: String, CaseIterable {
    case imperial
    case metric
    
    var index: Int {
        return MeasurementUnits.allCases.firstIndex(of: self) ?? 0
    }
}

internal enum Destination: Codable {
    case goalWeight
    case activityLevel
    case measurement
    case dayRange
    case monthlyRange
    case appleWatchConnect
    case miBandConnect
}

internal enum CalendarType: Int, Codable {
    case weekly
    case monthly
    case yearly
}

internal struct BorderStyles {
    static let classic: [NSNumber] = [4, 2]
    static let dotted: [NSNumber] = [1, 3]
    static let dottedDash: [NSNumber] = [8, 4, 2, 4]
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
