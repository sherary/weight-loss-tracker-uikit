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

internal let DayNames: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

internal enum MeasurementUnits: String, CaseIterable {
    case metric
    case imperial
    
    var index: Int {
        return MeasurementUnits.allCases.firstIndex(of: self) ?? 0
    }
    
    var name: String {
        let data = self.rawValue
        return "\(data.prefix(1).uppercased())\(data.suffix(data.count - 1))"
    }
}

internal enum Settings: CaseIterable {
    @Setting(key: SettingKey.goalWeight.name, defaultValue: 50)
    internal static var goalWeight: Double
    
    @Setting(key: SettingKey.activityLevel.name, defaultValue: 0)
    internal static var activityLevel: Double
    
    @Setting(key: SettingKey.measurement.name, defaultValue: 0)
    internal static var measurementUnit: Double
    
    @Setting(key: SettingKey.dayStart.name, defaultValue: 0)
    internal static var dayStart: Double
    
    @Setting(key: SettingKey.monthStart.name, defaultValue: 1)
    internal static var monthStart: Double
    
    @Setting(key: SettingKey.appleWatchConnect.name, defaultValue: 0)
    internal static var appleWatchConnect: Double
    
    @Setting(key: SettingKey.miBandConnect.name, defaultValue: 0)
    internal static var miBandConnect: Double
    
    internal static var items: [SettingItems] {
        return [
            SettingItems(id: SettingKey.goalWeight.name, name: SettingKey.goalWeight.title, value: Settings.goalWeight, destination: .goalWeight),
            SettingItems(id: SettingKey.activityLevel.name, name: SettingKey.activityLevel.title, value: Settings.activityLevel, destination: .activityLevel),
            SettingItems(id: SettingKey.measurement.name, name: SettingKey.measurement.title, value: Settings.measurementUnit, destination: .measurement),
            SettingItems(id: SettingKey.dayStart.name, name: SettingKey.dayStart.title, value: Settings.dayStart, destination: .dayStart),
            SettingItems(id: SettingKey.monthStart.name, name: SettingKey.monthStart.title, value: Settings.monthStart, destination: .monthStart),
            SettingItems(id: SettingKey.appleWatchConnect.name, name: SettingKey.appleWatchConnect.title, value: Settings.appleWatchConnect, destination: .appleWatchConnect),
            SettingItems(id: SettingKey.miBandConnect.name, name: SettingKey.miBandConnect.title, value: Settings.miBandConnect, destination: .miBandConnect)
        ]
    }
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

internal struct Empty {
    static let String: String = ""
}
