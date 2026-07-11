final class UserProfileViewModel {
    // MARK: - Properties
    internal var setting: SettingItems?
    
    // MARK: - Methods
    convenience init(setting: SettingItems) {
        self.init()
        
        self.setting = setting
    }
    
    internal func getOptions() -> [Option] {
        guard let setting = setting else { return [] }
        
        switch setting.destination {
        case .gender:
            return UserService.genderInfo
        default:
            return []
        }
    }
    
    internal func save(_ value: Int) {
        guard let setting = setting else { return }
        
        switch setting.destination {
        case .age:
            Settings.age = Int(value)
        case .gender:
            Settings.gender = Int(value)
        default:
            break
        }
    }
    
    internal func save(_ value: Double) {
        guard let setting = setting else { return }
        
        switch setting.destination {
        case .weight:
            Settings.weight = value
        case .height:
            Settings.height = value
        default:
            break
        }
    }
    
    internal func save(_ value: String) {
        guard let setting = setting else { return }
        
        switch setting.destination {
        case .firstName:
            Settings.firstName = value
        case .lastName:
            Settings.lastName = value
        case .username:
            Settings.username = value
        case .avatar:
            Settings.avatar = value
        default:
            break
        }
    }
    
    internal func resetToDefault(for key: SettingKey) {
        switch key {
        case .firstName:
            Settings.firstName = DefaultSettings.firstName
        case .lastName:
            Settings.lastName = DefaultSettings.lastName
        case .username:
            Settings.username = DefaultSettings.username
        case .weight:
            Settings.weight = DefaultSettings.weight
        case .height:
            Settings.height = DefaultSettings.height
        case .age:
            Settings.age = DefaultSettings.age
        case .avatar:
            Settings.avatar = Empty.String
        default:
            break;
        }
    }
    
    internal func getSetting(for key: String) -> SettingItems? {
        return UserService.getSetting(for: key)
    }
    
    internal func valueHandler(for value: SettingValue, index: Int) -> String {
        switch index {
        case 0, 1, 6:
            guard let name = value.stringValue else {
                return Empty.String
            }
            
            return name
        case 2:
            guard let index = value.intValue else {
                return Empty.String
            }
            let genders = Sex.allCases.enumerated().map { $0.element.description }
            let gender = genders[index]
            
            return "\(gender)"
        case 3:
            guard let age = value.intValue else {
                return Empty.String
            }
            
            return "\(age) y.o"
        case 4:
            guard let height = value.doubleValue else {
                return Empty.String
            }
            
            let unit = Settings.measurementUnit == MeasurementUnits.metric.index ? "cm" : "ft"
            
            return "\(height) \(unit)"
        case 5:
            guard let weight = value.doubleValue else {
                return Empty.String
            }
            
            let measurementUnit = Settings.measurementUnit == MeasurementUnits.metric.index ? "kg" : "lbs"
            
            return "\(weight) \(measurementUnit)"
        default:
            return Empty.String
        }
    }
}
