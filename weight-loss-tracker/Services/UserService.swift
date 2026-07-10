final class UserService {
    internal static var settingItems: [SettingItems] {
        Settings.profileItems
    }
    
    internal static func getSetting(for settingId: String) -> SettingItems? {
        return settingItems.first(where: { $0.id == settingId })
    }
    
    internal static var genderInfo: [Option] {
        let genders = Sex.allCases.enumerated()
        let options = genders.map {
            Option(
                title: $0.element.description,
                image: $0.element.image,
                value: $0.offset
            )
        }
        
        return options
    }
}
