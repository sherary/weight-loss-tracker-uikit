//
//  WeightGoalSettingsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 24/06/26.
//

import UIKit

final class WeightGoalSettingsViewController: UIViewController {
    private lazy var weightGoalSettingsView = WeightGoalSettingsView()
    private var setting: SettingItems?
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.weightGoalSettingsView.setting = setting
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
              let weightGoal = Double(weightInput)
        else { return }
        
        Settings.goalWeight = weightGoal
        
        navigationController?.popViewController(animated: true)
    }
}

