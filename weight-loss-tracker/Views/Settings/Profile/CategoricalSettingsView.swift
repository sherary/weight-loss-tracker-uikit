import UIKit

final class CategoricalSettingsView: UIView {
    fileprivate typealias MenuAction = (title: String, image: UIImage, value: Int)
    
    private lazy var openMenuBtn = UIButton()
    private lazy var titleLabel = UILabel()
    private lazy var label = UILabel()
    private lazy var hStack = UIStackView(arrangedSubviews: [label, openMenuBtn])
    
    internal private(set) var selectedValue: Int = 0
    
    internal lazy var saveBtn = UIButton()
    internal var options: [Option]? {
        didSet {
            guard let options = options, !options.isEmpty else { return }
            
            let parsedOptions = options.map { option in
                let fallback = UIImage(systemName: "questionmark.circle") ?? UIImage()
                let image = UIImage(systemName: option.image) ?? fallback
                
                return MenuAction(title: option.title, image: image, value: option.value)
            }
            
            buildMenu(with: parsedOptions)
        }
    }
    internal var setting: SettingItems? {
        didSet {
            guard let setting = setting else { return }
            
            if case .int(let value) = setting.value {
                selectedValue = value
            }
            
            updateLabel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    convenience init(options: [Option], setting: SettingItems) {
        self.init(frame: .zero)
        
        self.options = options
        self.setting = setting
    }
    
    convenience init(options: [Option]) {
        self.init(frame: .zero)
        
        self.options = options
    }
    
    convenience init(setting: SettingItems) {
        self.init(frame: .zero)
        
        self.setting = setting
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
        setConstraints()
    }
    
    private func buildMenu(with options: [MenuAction]) {
        let sortedOptions = options.sorted { $0.value > $1.value }
        let actions = sortedOptions.enumerated().map { (index, option) in
            UIAction(
                title: option.title,
                image: option.image,
                state: index == options.count - (selectedValue + 1) ? .on : .off,
                handler: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.selectedValue = option.value
                    self.updateLabel()
                    self.buildMenu(with: options)
                }
            )
        }
        
        let menu = UIMenu(title: "Select Option", children: actions)
        openMenuBtn.menu = menu
    }
    
    private func updateLabel() {
        guard let options = options, selectedValue < options.count else {
            label.text = "No selection"
            
            return
        }
        
        let selectedItem = options.first(where: { $0.value == selectedValue })
        label.text = selectedItem?.title
        openMenuBtn.configuration?.title = selectedItem?.title
    }
    
    private func setupLayout() {
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        var btnConfig = UIButton.Configuration.borderedProminent()
        btnConfig.title = "Save"
        btnConfig.baseBackgroundColor = .systemBlue
        btnConfig.baseForegroundColor = .white
        btnConfig.cornerStyle = .small
        btnConfig.titlePadding = 8
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        saveBtn.configuration = btnConfig
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        btnConfig.title = "Set"
        openMenuBtn.configuration = btnConfig
        openMenuBtn.showsMenuAsPrimaryAction = true
        openMenuBtn.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Choose Prefered"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(hStack)
        addSubview(saveBtn)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            
            hStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            saveBtn.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: 24),
            saveBtn.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
        ])
    }
}
