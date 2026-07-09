import UIKit

extension SettingsViewController: UITableViewDelegate {
    private func toTheNextNavigation(at destination: SettingKey, with settingId: String) {
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
            let appleWatchConnectVC = AppleWatchConnectSettingsViewController()
            appleWatchConnectVC.settingId = settingId
            
            vc = appleWatchConnectVC
        case .miBandConnect:
            let miBandConnectVC = MiBandConnectSettingsViewController()
            miBandConnectVC.settingId = settingId
            
            vc = miBandConnectVC
        default:
            return
        }
        
        guard let navController = navigationController else { return }
        navController.pushViewController(vc, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = settingSections[indexPath.section]
        let row = section.items[indexPath.row]
        guard let destination = row.destination else { return }
        
        self.toTheNextNavigation(at: destination, with: row.id)
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
