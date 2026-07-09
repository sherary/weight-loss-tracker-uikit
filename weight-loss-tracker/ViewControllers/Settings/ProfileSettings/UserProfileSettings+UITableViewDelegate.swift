import UIKit

extension UserProfileSettingsViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = self.userInfo[indexPath.row]
        
        self.presentSheet(for: selectedItem)
    }
}
