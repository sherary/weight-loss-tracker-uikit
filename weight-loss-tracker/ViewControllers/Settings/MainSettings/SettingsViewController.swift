import UIKit

final class SettingsViewController: UIViewController {
    private let settingsVM = SettingsViewModel()
    private let settingsView = SettingsView()
    internal var settingSections: [SettingSection] = []
    
    override func loadView() {
        self.view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settings")
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        
        settingsView.userAvatar.user = settingsVM.getUserInfo()
        settingsView.userAvatarOnTapToVC = { [weak self] in
            guard let self = self else { return }
            
            let vc = UserProfileSettingsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
