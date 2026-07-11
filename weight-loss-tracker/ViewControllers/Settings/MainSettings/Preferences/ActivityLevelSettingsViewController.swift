//
//  ActivityLevelViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import UIKit

final class ActivityLevelSettingsViewController: UIViewController {
    private let activityLevelSettingsView = ActivityLevelSettingsView()
    private var setting: SettingItems?
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.activityLevelSettingsView.setting = setting
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
        
        Settings.activityLevel = selectedRow
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
