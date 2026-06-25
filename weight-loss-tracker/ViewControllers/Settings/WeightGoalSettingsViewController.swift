//
//  WeightGoalSettingsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 24/06/26.
//

import UIKit

final class WeightGoalSettingsViewController: UIViewController {
    private lazy var weightGoalSettingsView = WeightGoalSettingsView()
    private var setting: SettingSection?
    
    internal var id: (sectionId: Int?, settingId: Int?) {
        didSet {
            if let sectionId = id.sectionId, let settingId = id.settingId {
                setting = getSettingSection(for: sectionId, and: settingId)
                
                guard let setting = setting,
                      let settingItem = setting.items.first(where: { $0.id == settingId })
                else { return }
                
                self.weightGoalSettingsView.setting = settingItem
            }
        }
    }
    
    override func loadView() {
        self.view = weightGoalSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Goal Settings"
        weightGoalSettingsView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    @objc private func saveSetting() {
        guard let weightInput = weightGoalSettingsView.textField.text,
              let weightGoal = Int(weightInput)
        else { return }
        
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY),
            var decodedData = try? JSONDecoder().decode([SettingSection].self, from: data),
            let setting = self.setting
        else { return }
        
        guard var settingItem = setting.items.first(where: { $0.id == id.settingId }) else {
            return
        }
        settingItem.value = weightGoal
        
        guard let index = decodedData.firstIndex(where: { $0.id == id.sectionId }),
            let item = decodedData.first(where: { $0.id == id.sectionId }),
            let itemIndex = item.items.firstIndex(where: { $0.id == id.settingId })
        else { return }

        decodedData[index].items[itemIndex] = settingItem
        
        guard let encodedData = try? JSONEncoder().encode(decodedData) else { return }
        
        UserDefaults.standard.set(encodedData, forKey: Configs.SETTINGS_KEY)
        navigationController?.popViewController(animated: true)
    }
    
    private func getSettingSection(for sectionId: Int, and settingId: Int) -> SettingSection? {
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY),
              let decodedData = try? JSONDecoder().decode([SettingSection].self, from: data),
              var settingSection = decodedData.first(where: { $0.id == sectionId })
        else { return nil }
        
        settingSection.items = settingSection.items.filter({ $0.id == settingId })
        
        return settingSection
    }
}
