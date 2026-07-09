//
//  MiBandConnectSettingsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/07/26.
//

import UIKit

final class MiBandConnectSettingsViewController: UIViewController {
    private let miBandConnectSettingsView = MiBandConnectSettingsView()
    private var setting: SettingItems?
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.miBandConnectSettingsView.setting = setting
            }
        }
    }
    
    override func loadView() {
        self.view = miBandConnectSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mi Band Connect Settings"
        
        miBandConnectSettingsView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
    }
    
    @objc private func saveSetting() {
        let isOn = miBandConnectSettingsView.switchView.isOn
        
        Settings.miBandConnect = isOn
        navigationController?.popViewController(animated: true)
    }
}
