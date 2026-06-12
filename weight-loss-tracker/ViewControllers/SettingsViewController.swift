//
//  StatsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private var settingsView: SettingsView { view as! SettingsView }
    
    override func loadView() {
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "Settings"
    }
}
