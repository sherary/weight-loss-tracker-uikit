//
//  StatsViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let settingsView = SettingsView()
    private var settingSections: [SettingSection] = []
    
    override func loadView() {
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settings")
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshUnitSetting()
    }
    
    private func refreshUnitSetting() {
        settingSections = SettingsService.getAvailableSettings()
        
        settingsView.tableView.reloadData()
    }
}

extension SettingsViewController {
    private func valueHandlerById(for id: String, with value: Double) -> String {
        switch id {
        case SettingKey.goalWeight.name:
            guard let weight = weightParser(value) else {
                return "\(value) kg"
            }
            
            return "\(Int(weight.number)) \(weight.unit)"
        case SettingKey.activityLevel.name:
            return SettingsService.activityLevelParser(Int(value))
        case SettingKey.measurement.name:
            return self.measurementUnitParser(Int(value))
        case SettingKey.dayStart.name:
            return self.dateRangeParser(Int(value))
        case SettingKey.monthStart.name:
            return self.monthlyRangeParser(Int(value))
        case SettingKey.appleWatchConnect.name, SettingKey.miBandConnect.name:
            return Int(value) == 0 ? "Not Connected" : "Connected"
        default:
            return "\(value)"
        }
    }
    
    private func weightParser(_ weight: Double) -> (number: Double, unit: String)? {
        var result: (number: Double, unit: String) = (number: 0, unit: "")
        let measurementUnitSettings = Settings.measurementUnit
        
        if Int(measurementUnitSettings) == MeasurementUnits.metric.index {
            result.number = Double(weight) / 2.20462
            result.unit = "kg"
        } else {
            result.number = Double(weight) * 2.20462
            result.unit = "lbs"
        }
        
        return result
    }
    
    private func measurementUnitParser(_ unit: Int) -> String {
        var result: String = ""
        
        for (index, item) in MeasurementUnits.allCases.enumerated() {
            if index == unit {
                let data = item.rawValue
                result = "\(data.prefix(1).uppercased())\(data.suffix(data.count - 1))"
            }
        }
        
        return result
    }
    
    private func dateRangeParser(_ num: Int) -> String {
        let days: [String] = DayNames
        var endIndex = num - 1
        if endIndex < 0 {
            endIndex = days.count - 1
        }
        
        return "\(days[num]) - \(days[endIndex])"
    }
    
    private func monthlyRangeParser(_ day: Int) -> String {
        var result = "Start at \(day)"
        
        switch day {
        case 1, 21, 31:
            result += "st"
        case 2, 22:
            result += "nd"
        case 3:
            result += "rd"
        default:
            result += "th"
        }
        
        return result
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingSections[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return settingSections[section].description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        let section = settingSections[indexPath.section]
        let rows = section.items[indexPath.row]
        
        config.text = rows.name
        config.secondaryText = self.valueHandlerById(for: rows.id, with: rows.value)
        
        config.prefersSideBySideTextAndSecondaryText = true
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    private func toTheNextNavigation(at destination: SettingKey, with sectionId: Int, and settingId: String) {
        let vc: UIViewController
        
        switch destination {
        case .goalWeight:
            let weightVC = WeightGoalSettingsViewController()
            weightVC.settingId = settingId
            
            vc = weightVC
        case .activityLevel:
            let activityLevelVC = ActivityLevelSettingsViewController()
            activityLevelVC.settingId = settingId
            
            vc = activityLevelVC
        case .measurement:
            let measurementVC = MeasurementUnitSettingsViewController()
            measurementVC.settingId = settingId
            
            vc = measurementVC
        case .dayStart:
            let dayStartVC = DayStartSettingsViewController()
            dayStartVC.settingId = settingId
            
            vc = dayStartVC
        case .monthStart:
            let monthStartVC = MonthlyStartSettingsViewController()
            monthStartVC.settingId = settingId
            
            vc = monthStartVC
        case .appleWatchConnect:
            return
        case .miBandConnect:
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = settingSections[indexPath.section]
        let row = section.items[indexPath.row]
        
        self.toTheNextNavigation(at: row.destination, with: section.id, and: row.id)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        let label = UILabel()
        label.text = settingSections[section].title
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 8)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
        ])
        
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
