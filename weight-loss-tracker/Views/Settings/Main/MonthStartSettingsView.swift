import UIKit

final class MonthStartSettingsView: UIView {
    private var label = UILabel()
    
    internal var alert = UIAlertController()
    internal var textField = UITextField()
    internal var saveBtn = UIButton()
    
    internal var setting: SettingItems? {
        didSet {
            guard let setting = setting,
                  let value = setting.value.intValue
            else { return }
            
            label.text = setting.name
            
            if value > 0 {
                textField.text = "\(Int(value))"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .natural
        
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.placeholder = 1.description
        textField.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        alert = UIAlertController(
            title: "Warning",
            message: "Your starting date cannot be less than 1 and more than 31",
            preferredStyle: .alert
        )
        
        var btnConfig = UIButton.Configuration.borderedProminent()
        btnConfig.title = "Save"
        btnConfig.baseBackgroundColor = .systemBlue
        btnConfig.baseForegroundColor = .white
        btnConfig.cornerStyle = .small
        btnConfig.titlePadding = 8
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        saveBtn.configuration = btnConfig
        
        let vStack = UIStackView(arrangedSubviews: [label, textField, saveBtn])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
