import UIKit

final class UserProfileSettingsViewController: UIViewController, UISheetPresentationControllerDelegate {
    private var userProfileView = UserProfileSettingsView()
    private lazy var viewModel = UserProfileViewModel(viewController: self)
    
    internal var userInfo: [SettingItems] {
        viewModel.userInfo
    }
    
    override func loadView() {
        view = userProfileView
    }
    
    override func viewDidLoad() {
        userProfileView.userAvatar.editBtn.addTarget(
            self,
            action: #selector(editAvatarOnTap),
            for: .touchUpInside
        )
        
        userProfileView.userInfoTable.register(UITableViewCell.self, forCellReuseIdentifier: "UserInfoCell")
        userProfileView.userInfoTable.dataSource = self
        userProfileView.userInfoTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshDataTable()
    }
    
    private func refreshDataTable() {
        userProfileView.userInfoTable.reloadData()
    }
    
    internal func presentSheet(for setting: SettingItems) {
        var vc = UIViewController()
        
        switch setting.destination {
        case .firstName, .lastName, .username:
            let nameVC = NameSettingsViewController()
            nameVC.settingId = setting.id
            nameVC.title = setting.name
            nameVC.onDismiss = { [weak self] in
                guard let self = self else { return }
                
                self.refreshDataTable()
            }
            
            vc = nameVC
        default:
            return
        }
        
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.delegate = self
        }
        
        present(nav, animated: true)
    }
    
    @objc private func editAvatarOnTap() {
        print("avatar tapped")
    }
}

// dismiss behavior
extension UserProfileSettingsViewController: UIAdaptivePresentationControllerDelegate {
    internal func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        refreshDataTable()
    }
}
