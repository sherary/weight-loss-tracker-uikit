import UIKit

@propertyWrapper
internal struct Setting<T: Equatable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            let current = UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            guard current != newValue else { return }
            
            UserDefaults.standard.set(newValue, forKey: key)
            NotificationCenter.default.post(name: .settingsDidChange, object: nil)
        }
    }
}

internal enum SettingKey: String, CaseIterable, Codable {
    case goalWeight = "goal_weight"
    case activityLevel = "activity_level"
    case measurement = "measurement_unit"
    case dayStart = "day_start"
    case monthStart = "month_start"
    case appleWatchConnect = "apple_watch"
    case miBandConnect = "mi_band"
    
    case firstName = "first_name"
    case lastName = "last_name"
    case gender = "gender"
    case age = "age"
    case height = "height"
    case weight = "weight"
    case username = "username"
    case avatar = "avatar"
    
    var name: String {
        return self.rawValue
    }
    
    var title: String {
        var result = ""
        var symbolMarked = false
        
        for (index, string) in self.rawValue.enumerated() {
            if index == 0 || symbolMarked {
                result.append(string.uppercased())
                symbolMarked = false
                
                continue
            }
            
            if string == "_" {
                result.append(" ")
                symbolMarked = true
                
                continue
            }
            
            result.append(string)
        }
        
        return result
    }
}

internal struct SettingSection: Codable {
    var id: Int
    var title: String
    var items: [SettingItems]
    var description: String?
    
    init(sectionId: Int = 0, title: String, items: [SettingItems], description: String? = nil) {
        self.id = sectionId
        self.title = title
        self.items = items
        self.description = description
    }
}

internal struct SettingItems: Codable {
    var id: String
    var name: String
    var value: SettingValue
    var destination: SettingKey?
    
    init(id: String, name: String, value: SettingValue, destination: SettingKey? = nil) {
        self.id = id
        self.name = name
        self.value = value
        self.destination = destination
    }
}

internal enum SettingValue: Codable, Equatable {
    case double(Double)
    case int(Int)
    case string(String)
    case bool(Bool)
    
    var doubleValue: Double? {
        if case .double(let value) = self { return value }
        return nil
    }
    
    var intValue: Int? {
        if case .int(let value) = self { return value }
        return nil
    }
    
    var stringValue: String? {
        if case .string(let value) = self { return value }
        return nil
    }
    
    var boolValue: Bool? {
        if case .bool(let value) = self { return value }
        return nil
    }
}
