import UIKit

final class MonthlyStartSettingsViewController: UIViewController {
    private var monthlyStartSettingsView = MonthStartSettingsView()
    private var setting: SettingItems?
    
    override func loadView() {
        view = monthlyStartSettingsView
    }
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                monthlyStartSettingsView.setting = setting
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Starting Month Settings"
        
        monthlyStartSettingsView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    private func validatorWarning() {
        if monthlyStartSettingsView.alert.actions.isEmpty {
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            
            monthlyStartSettingsView.alert.addAction(action)
        }
        
        self.present(monthlyStartSettingsView.alert, animated: true)
    }
    
    @objc private func saveSetting() {
        guard let data = monthlyStartSettingsView.textField.text,
            let startingDate = Int(data),
        startingDate > 0 && startingDate <= 31 else {
            validatorWarning()
            
            return
        }
        
        Settings.monthStart = startingDate
        navigationController?.popViewController(animated: true)
    }
}
