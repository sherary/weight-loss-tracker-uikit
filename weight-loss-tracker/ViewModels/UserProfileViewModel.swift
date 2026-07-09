final class UserProfileViewModel: ViewModel<UserProfileSettingsViewController> {
    var userInfo: [SettingItems] {
        return UserService.settingItems
    }
    
    override init(viewController: UserProfileSettingsViewController) {
        super.init(viewController: viewController)
    }
}
