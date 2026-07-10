import UIKit

final class NumericalSettingsViewController: UIViewController {
    private lazy var numericalSettingsView = NumericalSettingsView()
    private var setting: SettingItems?
    
    internal var onDismiss: ((String) -> Void)?
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                guard let setting = UserService.getSetting(for: settingId) else {
                    return
                }
                
                self.setting = setting
                self.numericalSettingsView.value = setting.value
                self.title = setting.name
            }
        }
    }
    
    override func loadView() {
        self.view = numericalSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numericalSettingsView.saveBtn.addTarget(
            self,
            action: #selector(saveSetting),
            for: .touchUpInside
        )
    }
    
    @objc private func saveSetting() {
        guard let value = numericalSettingsView.selectedValue else {
            return
        }
        
        onDismiss?(value)
        dismiss(animated: true)
    }
}
