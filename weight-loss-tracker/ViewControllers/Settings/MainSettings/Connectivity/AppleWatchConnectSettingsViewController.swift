//
//  AppleWatchConnectSettingsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/07/26.
//

import UIKit

final class AppleWatchConnectSettingsViewController: UIViewController {
    private let appleWatchConnectView = AppleWatchConnectSettingsView()
    private var setting: SettingItems?
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.appleWatchConnectView.setting = setting
            }
        }
    }
    
    override func loadView() {
        self.view = appleWatchConnectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apple Watch Connect Settings"
        
        appleWatchConnectView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    @objc private func saveSetting() {
        let isOn = appleWatchConnectView.switchView.isOn
        
        Settings.appleWatchConnect = isOn
        navigationController?.popViewController(animated: true)
    }
}
