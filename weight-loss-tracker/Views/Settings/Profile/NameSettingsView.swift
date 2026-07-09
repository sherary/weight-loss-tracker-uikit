import UIKit

final class NameSettingsView: UIView {
    internal lazy var textField = UITextField()
    internal lazy var saveBtn = UIButton()
    
    internal var setting: SettingItems? {
        didSet {
            guard let setting = setting else { return }
            
            textField.text = setting.value.stringValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
        setConstraints()
    }
    
    private func setupLayout() {
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        textField.keyboardType = .alphabet
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        var btnConfig = UIButton.Configuration.borderedProminent()
        btnConfig.title = "Save"
        btnConfig.baseBackgroundColor = .systemBlue
        btnConfig.baseForegroundColor = .white
        btnConfig.cornerStyle = .small
        btnConfig.titlePadding = 8
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        saveBtn.configuration = btnConfig
        saveBtn.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        addSubview(saveBtn)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            saveBtn.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            saveBtn.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ])
    }
}
