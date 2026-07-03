//
//  MeasurementUnitSettingsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import UIKit

final class MeasurementUnitSettingsViewController: UIViewController {
    private let measurementView = MeasurementUnitSettingsView()
    private var setting: SettingItems?
    private var measurementUnits: [String] = []
    private var selectedIndex = 0 {
        didSet {
            if selectedIndex > 1 || selectedIndex < 0 {
                selectedIndex = 0
            }
        }
    }
    
    internal var settingId: String? {
        didSet {
            if let settingId = settingId {
                setting = SettingsService.getSetting(for: settingId)
                
                self.measurementView.setting = setting
                guard let setting = setting else { return }
                self.selectedIndex = Int(setting.value)
            }
        }
    }
    
    override func loadView() {
        self.view = measurementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Unit of Measurements Settings"
        
        measurementView.saveBtn.addTarget(self, action: #selector(saveSetting), for: .touchUpInside)
        
        measurementView.onTappedToVC = { [weak self] action in
            guard let self = self else { return }
            
            if action > 0 {
                selectedIndex += action
            } else {
                selectedIndex -= action
            }
            
            measurementView.textCarousel.text = measurementUnits[selectedIndex]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllMeasurementUnits()
        
        measurementView.textCarousel.text = measurementUnits[selectedIndex]
    }
    
    private func getAllMeasurementUnits() {
        measurementUnits.removeAll()
        
        for (_, item) in MeasurementUnits.allCases.enumerated() {
            measurementUnits.append(item.name)
        }
    }
    
    @objc private func saveSetting() {
        Settings.measurementUnit = Double(selectedIndex)
        navigationController?.popViewController(animated: true)
    }
}
