import UIKit

final class CategoricalSettingsViewController: UIViewController {
    private lazy var categoricalSettingsView = CategoricalSettingsView()
    private var setting: SettingItems?
    
    internal var onDismiss: ((Int) -> Void)?
    internal var options: [Option]? {
        didSet {
            categoricalSettingsView.options = options
        }
    }
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                guard let options = options, !options.isEmpty else { return }
                
                setting = UserService.getSetting(for: settingId)
                self.categoricalSettingsView.setting = setting
                
                guard let setting = setting else { return }
                self.title = setting.name
            }
        }
    }
    
    override func loadView() {
        self.view = categoricalSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoricalSettingsView.saveBtn.addTarget(
            self,
            action: #selector(saveSetting),
            for: .touchUpInside
        )
    }
    
    @objc private func saveSetting() {
        let value = categoricalSettingsView.selectedValue
        
        onDismiss?(value)
        dismiss(animated: true)
    }
}
