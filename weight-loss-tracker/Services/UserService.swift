final class UserService {
    internal static var settingItems: [SettingItems] {
        Settings.profileItems
    }
    
    internal static func getSetting(for settingId: String) -> SettingItems? {
        return settingItems.first(where: { $0.id == settingId })
    }
}
