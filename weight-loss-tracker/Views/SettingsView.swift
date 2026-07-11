import UIKit

final class SettingsView: UIView {
    internal var userAvatar = UserAvatarView(context: .settings)
    internal var tableView = UITableView(frame: .zero, style: .insetGrouped)
    internal lazy var hStack = UIStackView(arrangedSubviews: [userAvatar, tableView])
    
    internal var userAvatarOnTapToVC: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        setupLayout()
        
        userAvatar.onTap = { [weak self] in
            self?.userAvatarOnTapToVC?()
        }
    }
    
    private func setupLayout() {
        self.backgroundColor = .secondarySystemBackground
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.context = .settings
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.setContentHuggingPriority(.required, for: .vertical)
        userAvatar.setContentCompressionResistancePriority(.required, for: .vertical)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        hStack.axis = .vertical
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
