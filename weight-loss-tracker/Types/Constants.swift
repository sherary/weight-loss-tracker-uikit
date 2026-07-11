import CoreFoundation
import UIKit

internal enum Sex: String, CaseIterable {
    case male
    case female
    case others
    
    var index: Int {
        return Sex.allCases.firstIndex(of: self) ?? 0
    }
    
    var description: String {
        let data = self.rawValue
        return "\(data.prefix(1).uppercased())\(data.suffix(data.count - 1))"
    }
    
    var image: String {
        switch self {
        case .male:
            return "figure.stand"
        case .female:
            return "figure.stand.dress"
        case .others:
            return "figure.stand.dress.line.vertical"
        }
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

internal enum DefaultSettings {
    static let goalWeight: Double = 50
    static let activityLevel = 0
    static let measurementUnit = 0
    static let dayStart = 0
    static let monthStart = 0
    static let appleWatchConnect = false
    static let miBandConnect = false
    
    static let firstName = "Jane"
    static let lastName = "Doe"
    static let gender = 0
    static let age = 20
    static let weight: Double = 60
    static let height: Double = 160
    static let username = "jane_doe"
    static let avatar = Empty.String
}

internal enum Settings: CaseIterable {
    @Setting(key: SettingKey.goalWeight.name, defaultValue: DefaultSettings.goalWeight)
    internal static var goalWeight: Double
    
    @Setting(key: SettingKey.activityLevel.name, defaultValue: DefaultSettings.activityLevel)
    internal static var activityLevel: Int
    
    @Setting(key: SettingKey.measurement.name, defaultValue: DefaultSettings.measurementUnit)
    internal static var measurementUnit: Int
    
    @Setting(key: SettingKey.dayStart.name, defaultValue: DefaultSettings.dayStart)
    internal static var dayStart: Int
    
    @Setting(key: SettingKey.monthStart.name, defaultValue: DefaultSettings.monthStart)
    internal static var monthStart: Int
    
    @Setting(key: SettingKey.appleWatchConnect.name, defaultValue: DefaultSettings.appleWatchConnect)
    internal static var appleWatchConnect: Bool
    
    @Setting(key: SettingKey.miBandConnect.name, defaultValue: DefaultSettings.miBandConnect)
    internal static var miBandConnect: Bool
    
    @Setting(key: SettingKey.firstName.name, defaultValue: DefaultSettings.firstName)
    internal static var firstName: String
    
    @Setting(key: SettingKey.lastName.name, defaultValue: DefaultSettings.lastName)
    internal static var lastName: String
    
    @Setting(key: SettingKey.gender.name, defaultValue: DefaultSettings.gender)
    internal static var gender: Int
    
    @Setting(key: SettingKey.age.name, defaultValue: DefaultSettings.age)
    internal static var age: Int
    
    @Setting(key: SettingKey.height.name, defaultValue: DefaultSettings.height)
    internal static var height: Double
    
    @Setting(key: SettingKey.weight.name, defaultValue: DefaultSettings.weight)
    internal static var weight: Double
    
    @Setting(key: SettingKey.username.name, defaultValue: DefaultSettings.username)
    internal static var username: String
    
    @Setting(key: SettingKey.avatar.name, defaultValue: DefaultSettings.avatar)
    internal static var avatar: String
    
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
                id: SettingKey.gender.name,
                name: SettingKey.gender.title,
                value: .int(Settings.gender),
                destination: .gender
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
                value: .double(Settings.height),
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
            SettingItems(
                id: SettingKey.avatar.name,
                name: SettingKey.avatar.title,
                value: .string(Settings.avatar),
                destination: .avatar
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
