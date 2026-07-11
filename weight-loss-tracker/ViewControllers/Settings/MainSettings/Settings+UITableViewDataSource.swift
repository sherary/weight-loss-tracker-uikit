import UIKit

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
        let settingsVM = SettingsViewModel()
        
        config.text = rows.name
        config.secondaryText = settingsVM.valueHandlerById(for: rows.id, with: rows.value)
        
        config.prefersSideBySideTextAndSecondaryText = true
        
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
