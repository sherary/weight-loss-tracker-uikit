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
    internal static var activityLevel: Int
    
    @Setting(key: SettingKey.measurement.name, defaultValue: 0)
    internal static var measurementUnit: Int
    
    @Setting(key: SettingKey.dayStart.name, defaultValue: 0)
    internal static var dayStart: Int
    
    @Setting(key: SettingKey.monthStart.name, defaultValue: 1)
    internal static var monthStart: Int
    
    @Setting(key: SettingKey.appleWatchConnect.name, defaultValue: false)
    internal static var appleWatchConnect: Bool
    
    @Setting(key: SettingKey.miBandConnect.name, defaultValue: false)
    internal static var miBandConnect: Bool
    
    @Setting(key: SettingKey.firstName.name, defaultValue: "Jane")
    internal static var firstName: String
    
    @Setting(key: SettingKey.lastName.name, defaultValue: "Doe")
    internal static var lastName: String
    
    @Setting(key: SettingKey.sex.name, defaultValue: 0)
    internal static var sex: Int
    
    @Setting(key: SettingKey.age.name, defaultValue: 20)
    internal static var age: Int
    
    @Setting(key: SettingKey.height.name, defaultValue: 160)
    internal static var height: Int
    
    @Setting(key: SettingKey.weight.name, defaultValue: 60)
    internal static var weight: Double
    
    @Setting(key: SettingKey.username.name, defaultValue: Settings.firstName.lowercased() + Settings.lastName.lowercased())
    internal static var username: String
    
    internal static var profileItems: [SettingItems] {
        return [
            SettingItems(
                id: SettingKey.firstName.name,
                name: SettingKey.firstName.title,
                value: .string(Settings.firstName),
                destination: .firstName
            ),
            SettingItems(
                id: SettingKey.lastName.name,
                name: SettingKey.lastName.title,
                value: .string(Settings.lastName),
                destination: .lastName
            ),
            SettingItems(
                id: SettingKey.sex.name,
                name: SettingKey.sex.title,
                value: .int(Settings.sex),
                destination: .sex
            ),
            SettingItems(
                id: SettingKey.age.name,
                name: SettingKey.age.title,
                value: .int(Settings.age),
                destination: .age
            ),
            SettingItems(
                id: SettingKey.height.name,
                name: SettingKey.height.title,
                value: .int(Settings.height),
                destination: .height
            ),
            SettingItems(
                id: SettingKey.weight.name,
                name: SettingKey.weight.title,
                value: .double(Settings.weight),
                destination: .weight
            ),
            SettingItems(
                id: SettingKey.username.name,
                name: SettingKey.username.title,
                value: .string(Settings.username),
                destination: .username
            ),
        ]
    }
    
    internal static var generalItems: [SettingItems] {
        return [
            SettingItems(
                id: SettingKey.goalWeight.name,
                name: SettingKey.goalWeight.title,
                value: .double(Settings.goalWeight),
                destination: .goalWeight
            ),
            SettingItems(
                id: SettingKey.activityLevel.name,
                name: SettingKey.activityLevel.title,
                value: .int(Settings.activityLevel),
                destination: .activityLevel
            ),
            SettingItems(
                id: SettingKey.measurement.name,
                name: SettingKey.measurement.title,
                value: .int(Settings.measurementUnit),
                destination: .measurement
            ),
            SettingItems(
                id: SettingKey.dayStart.name,
                name: SettingKey.dayStart.title,
                value: .int(Settings.dayStart),
                destination: .dayStart
            ),
            SettingItems(
                id: SettingKey.monthStart.name,
                name: SettingKey.monthStart.title,
                value: .int(Settings.monthStart),
                destination: .monthStart
            ),
            SettingItems(
                id: SettingKey.appleWatchConnect.name,
                name: SettingKey.appleWatchConnect.title,
                value: .bool(Settings.appleWatchConnect),
                destination: .appleWatchConnect
            ),
            SettingItems(
                id: SettingKey.miBandConnect.name,
                name: SettingKey.miBandConnect.title,
                value: .bool(Settings.miBandConnect),
                destination: .miBandConnect
            )
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

internal enum Context {
    case settings
    case editProfile
}
