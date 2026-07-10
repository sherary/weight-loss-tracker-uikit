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
        config.secondaryText = viewModel.valueHandler(for: entry.value, index: indexPath.row)
        config.prefersSideBySideTextAndSecondaryText = true
        config.textProperties.font = .systemFont(ofSize: 16)
        config.secondaryTextProperties.color = .secondaryLabel
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        cell.contentConfiguration = config
        
        return cell
    }
}
