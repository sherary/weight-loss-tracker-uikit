import UIKit

final class DayStartSettingsViewController: UIViewController {
    private let dayStartSettingsView = DayStartSettingsView()
    private var setting: SettingItems?
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.dayStartSettingsView.setting = setting
            }
        }
    }
    
    override func loadView() {
        self.view = dayStartSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Starting Day Settings"
        
        dayStartSettingsView.pickerView.dataSource = self
        dayStartSettingsView.pickerView.delegate = self
        
        dayStartSettingsView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    @objc private func saveSetting() {
        let selectedRow = Double(dayStartSettingsView.pickerView.selectedRow(inComponent: 0))
        
        Settings.dayStart = selectedRow
        navigationController?.popViewController(animated: true)
    }
}

extension DayStartSettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsService.shared.dayNames.count
    }
}

extension DayStartSettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SettingsService.shared.dayNames[row]
    }
}
