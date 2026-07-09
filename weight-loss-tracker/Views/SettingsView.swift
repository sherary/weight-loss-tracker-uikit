import UIKit

final class SettingsView: UIView {
    internal var userAvatar = UserAvatarView()
    internal var tableView = UITableView(frame: .zero, style: .insetGrouped)
    internal var userAvatarOnTapToVC: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        userAvatar.onTap = { [weak self] in
            self?.userAvatarOnTapToVC?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.backgroundColor = .secondarySystemBackground
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(userAvatar)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            userAvatar.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            userAvatar.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            userAvatar.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: userAvatar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
