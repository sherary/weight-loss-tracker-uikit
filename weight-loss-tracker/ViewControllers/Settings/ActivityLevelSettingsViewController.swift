//
//  ActivityLevelViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import UIKit

final class ActivityLevelSettingsViewController: UIViewController {
    private let activityLevelSettingsView = ActivityLevelSettingsView()
    private var setting: SettingSection?
    
    internal var id: (sectionId: Int?, settingId: Int?) {
        didSet {
            if let sectionId = id.sectionId, let settingId = id.settingId {
                setting = SettingsService.getSettingSection(for: sectionId, and: settingId)
                
                guard let setting = setting,
                      let settingItem = setting.items.first(where: { $0.id == settingId })
                else { return }
                
                self.activityLevelSettingsView.setting = settingItem
            }
        }
    }
    
    override func loadView() {
        self.view = activityLevelSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Activity Level Settings"
        
        activityLevelSettingsView.pickerView.dataSource = self
        activityLevelSettingsView.pickerView.delegate = self
        
        activityLevelSettingsView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    @objc private func saveSetting() {
        let selectedRow = activityLevelSettingsView.pickerView.selectedRow(inComponent: 0)
        
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY),
            var decodedData = try? JSONDecoder().decode([SettingSection].self, from: data),
            let setting = self.setting
        else { return }
        
        guard var settingItem = setting.items.first(where: { $0.id == id.settingId }) else {
            return
        }
        settingItem.value = selectedRow
        
        guard let index = decodedData.firstIndex(where: { $0.id == id.sectionId }),
            let item = decodedData.first(where: { $0.id == id.sectionId }),
            let itemIndex = item.items.firstIndex(where: { $0.id == id.settingId })
        else { return }

        decodedData[index].items[itemIndex] = settingItem
        
        guard let encodedData = try? JSONEncoder().encode(decodedData) else { return }
        
        UserDefaults.standard.set(encodedData, forKey: Configs.SETTINGS_KEY)
        navigationController?.popViewController(animated: true)
    }
}

extension ActivityLevelSettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SettingsService.shared.activityLevels.count
    }
}

extension ActivityLevelSettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SettingsService.shared.activityLevels[row]
    }
}
