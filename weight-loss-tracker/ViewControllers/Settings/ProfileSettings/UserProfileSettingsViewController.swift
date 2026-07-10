import UIKit

final class UserProfileSettingsViewController: UIViewController, UISheetPresentationControllerDelegate {
    private var userProfileView = UserProfileSettingsView()
    internal lazy var viewModel = UserProfileViewModel()
    
    internal var userInfo: [SettingItems] {
        UserService.settingItems
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
        viewModel.setting = setting
        
        switch setting.destination {
        case .firstName, .lastName, .username:
            let textVC = TextSettingsViewController()
            textVC.settingId = setting.id
            textVC.title = setting.name
            textVC.onDismiss = { [weak self] txt in
                guard let self = self else { return }
                
                viewModel.save(txt)
                self.refreshDataTable()
            }
            
            vc = textVC
        case .age:
            let numericalVC = NumericalSettingsViewController()
            numericalVC.settingId = setting.id
            numericalVC.title = setting.name
            numericalVC.onDismiss = { [weak self] num in
                guard let self = self,
                      let value = Int(num)
                else { return }
                
                viewModel.save(value)
                self.refreshDataTable()
            }
            
            vc = numericalVC
        case .weight, .height:
            let numericalVC = NumericalSettingsViewController()
            numericalVC.settingId = setting.id
            numericalVC.title = setting.name
            numericalVC.onDismiss = { [weak self] num in
                guard let self = self,
                      let value = Double(num)
                else { return }
                
                viewModel.save(value)
                self.refreshDataTable()
            }
            
            vc = numericalVC
        case .sex:
            let categoricalVC = CategoricalSettingsViewController()
            categoricalVC.options = UserService.genderInfo
            categoricalVC.settingId = setting.id
            categoricalVC.title = setting.name
            categoricalVC.onDismiss = { [weak self] num in
                guard let self = self else { return }
                
                viewModel.save(num)
                self.refreshDataTable()
            }
            
            vc = categoricalVC
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
