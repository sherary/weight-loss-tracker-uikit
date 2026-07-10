import UIKit

final class TextSettingsView: UIView {
    private var textField = UITextField()
    
    internal var saveBtn = UIButton()
    internal private(set) var selectedValue: String?
    internal var value: String? {
        didSet {
            textField.text = value
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        textField.addAction(UIAction { [weak self] action in
            guard let sender = action.sender as? UITextField,
                  let self = self
            else { return }
            
            selectedValue = sender.text
        }, for: .editingChanged)
        
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
