import UIKit

final class TextSettingsViewController: UIViewController {
    private lazy var txtSettingView = TextSettingsView()
    private var setting: SettingItems?
    
    internal var onDismiss: ((String) -> Void)?
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                guard let setting = UserService.getSetting(for: settingId) else {
                    return
                }
                
                self.setting = setting
                self.txtSettingView.value = setting.value.stringValue
                self.title = setting.name
            }
        }
    }
    
    override func loadView() {
        self.view = txtSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSettingView.saveBtn.addTarget(
            self,
            action: #selector(saveSetting),
            for: .touchUpInside
        )
    }
    
    @objc private func saveSetting() {
        guard let textInput = txtSettingView.selectedValue else { return }
        
        onDismiss?(textInput)
        dismiss(animated: true)
    }
}
