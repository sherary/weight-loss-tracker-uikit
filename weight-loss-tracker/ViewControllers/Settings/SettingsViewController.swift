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
    
    private func getAvailableSettings() -> [SettingSection] {
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([SettingSection].self, from: data) else { return [] }
        
        return decodedData
    }
    
    private func refreshUnitSetting() {
        settingSections = self.getAvailableSettings()
        
        settingsView.tableView.reloadData()
    }
}

extension SettingsViewController {
    private func valueHandlerById(for id: Int, with value: Int) -> String {
        switch id {
        case 1:
            return "\(value) kg"
        case 2:
            return self.activityLevelParser(value)
        case 3:
            return self.measurementUnitParser(value)
        case 4:
            return self.dateRangeParser(value)
        case 5:
            return self.monthlyRangeParser(value)
        case 6, 7:
            return value == 0 ? "Not Connected" : "Connected"
        default:
            return "\(value)"
        }
    }
    
    private func activityLevelParser(_ level: Int) -> String {
        let activityLevel = ["Sedentary", "Light Activity", "Moderate Activity", "Intense Activity", "Athlete"]
        return activityLevel[level]
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
        let days: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
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
    private func toTheNextNavigation(at destination: Destination, with sectionId: Int, and settingId: Int) {
        let vc: UIViewController
        
        switch destination {
        case .goalWeight:
            let weightVC = WeightGoalSettingsViewController()
            weightVC.id = (sectionId: sectionId, settingId: settingId)
            
            vc = weightVC
        case .activityLevel:
            return
        case .measurement:
            return
        case .dayRange:
            return
        case .monthlyRange:
            return
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
