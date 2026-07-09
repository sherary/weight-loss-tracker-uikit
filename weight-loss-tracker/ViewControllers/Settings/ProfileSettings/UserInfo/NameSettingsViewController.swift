import UIKit

final class NameSettingsViewController: UIViewController {
    private lazy var nameSettingsView = NameSettingsView()
    private var setting: SettingItems?
    
    internal var onDismiss: (() -> Void)?
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = UserService.getSetting(for: settingId)
                
                self.nameSettingsView.setting = setting
                
                guard let setting = setting else {
                    return
                }
                
                self.title = setting.name
            }
        }
    }
    
    override func loadView() {
        self.view = nameSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameSettingsView.saveBtn.addTarget(
            self,
            action: #selector(saveSetting),
            for: .touchUpInside
        )
    }
    
    @objc private func saveSetting() {
        guard let setting = setting,
              let destination = setting.destination,
              let nameInput = nameSettingsView.textField.text else {
            return
        }
        
        switch destination {
        case .firstName:
            Settings.firstName = nameInput
        case .lastName:
            Settings.lastName = nameInput
        case .username:
            Settings.username = nameInput
        default:
            break
        }
        
        onDismiss?()
        dismiss(animated: true)
    }
}
