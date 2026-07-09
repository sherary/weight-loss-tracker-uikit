import UIKit

extension UserProfileSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoCell", for: indexPath)
        
        let entry = self.userInfo[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = entry.name
        config.secondaryText = valueHandler(for: entry.value, index: indexPath.row)
        config.prefersSideBySideTextAndSecondaryText = true
        config.textProperties.font = .systemFont(ofSize: 16)
        config.secondaryTextProperties.color = .secondaryLabel
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        cell.contentConfiguration = config
        
        return cell
    }
    
    private func valueHandler(for value: SettingValue, index: Int) -> String {
        switch index {
        case 0, 1, 6:
            guard let stringValue = value.stringValue else {
                return Empty.String
            }
            
            return stringValue
        case 2:
            guard let intValue = value.intValue else {
                return Empty.String
            }
            let sex = intValue == 0 ? "Female" : "Male"
            
            return "\(sex)"
        case 3:
            guard let intValue = value.intValue else {
                return Empty.String
            }
            
            return "\(intValue) y.o"
        case 4:
            guard let intValue = value.intValue else {
                return Empty.String
            }
            
            let unit = Settings.measurementUnit == MeasurementUnits.metric.index ? "cm" : "ft"
            
            return "\(intValue) \(unit)"
        case 5:
            guard let doubleValue = value.doubleValue else {
                return Empty.String
            }
            
            let measurementUnit = Settings.measurementUnit == MeasurementUnits.metric.index ? "kg" : "lbs"
            
            return "\(Int(doubleValue)) \(measurementUnit)"
        default:
            return Empty.String
        }
    }
}
