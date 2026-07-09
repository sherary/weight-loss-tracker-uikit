import UIKit

final class UserProfileSettingsView: UIView {
    internal lazy var userAvatar = UserAvatarView(context: .editProfile)
    internal lazy var userInfoTable = UITableView()
    internal lazy var hStack = UIStackView(arrangedSubviews: [userAvatar, userInfoTable])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.backgroundColor = .secondarySystemBackground
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        
        userAvatar.context = .editProfile
        userAvatar.translatesAutoresizingMaskIntoConstraints = false
        userAvatar.setContentHuggingPriority(.required, for: .vertical)
        userAvatar.setContentCompressionResistancePriority(.required, for: .vertical)
        
        userInfoTable.translatesAutoresizingMaskIntoConstraints = false
        userInfoTable.setContentHuggingPriority(.defaultLow, for: .vertical)
        userInfoTable.layer.cornerRadius = 20
        
        hStack.axis = .vertical
        hStack.spacing = 30
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            userInfoTable.heightAnchor.constraint(equalToConstant: 370),
            
            hStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
