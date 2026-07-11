import UIKit

final class UserAvatarView: UIView {
    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    private lazy var hStack: UIStackView = UIStackView(arrangedSubviews: [imageView, label])
    
    private var imgWidth = NSLayoutConstraint()
    private var imgHeight = NSLayoutConstraint()
    
    internal lazy var editBtn: UIButton = UIButton()
    internal var onTap: (() -> Void)?
    internal var user: Users? {
        didSet {
            setAvailableData(for: user)
        }
    }
    internal var context: Context = .settings {
        didSet {
            handleContext()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 160)
    }
    
    convenience init(context: Context) {
        self.init(frame: .zero)
        self.context = context
        
        handleContext()
    }
    
    override init(frame: CGRect) {
        self.context = .settings
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.context = .settings
        super.init(coder: coder)
     
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageSize()
        
        hStack.layoutIfNeeded()
        imageView.layoutIfNeeded()

        imageView.layer.cornerRadius = min(imageView.bounds.width, imageView.bounds.height) / 2
        imageView.layer.cornerCurve = .continuous
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 0.8
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 1.0
        }
    }
    
    private func commonInit() {
        setupLayout()
        setupConstraints()
        setAvailableData(for: user)
        setupTapGesture()
        handleContext()
    }
    
    private func updateImageSize() {
        guard bounds.height > 0 else { return }
        
        var newSize: CGFloat = 0
        
        switch context {
        case .settings:
            newSize = bounds.height * 0.6
        case .editProfile:
            newSize = bounds.height * 0.9
        }
        
        imgWidth.constant = newSize
        imgHeight.constant = newSize
    }
    
    private func handleContext() {
        switch context {
        case .settings:
            editBtn.isHidden = true
            
            hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            hStack.addArrangedSubview(imageView)
            hStack.addArrangedSubview(label)
            
        case .editProfile:
            editBtn.isHidden = false
            
            hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            hStack.addArrangedSubview(imageView)
            hStack.addArrangedSubview(editBtn)
        }
    }
    
    private func setupConstraints() {
        imgWidth = imageView.widthAnchor.constraint(equalToConstant: intrinsicContentSize.height / 2)
        imgHeight = imageView.heightAnchor.constraint(equalToConstant: intrinsicContentSize.height / 2)
        
        imgWidth.priority = .defaultHigh
        imgHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            imgWidth,
            imgHeight,
            
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            hStack.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        animatePress()
        
        onTap?()
    }
    
    private func animatePress() {
        UIView.animate(withDuration: 0.1, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.imageView.alpha = 0.6
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.imageView.transform = .identity
                self.imageView.alpha = 1.0
            }
        }
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        var btnConfig = UIButton.Configuration.borderedTinted()
        btnConfig.title = "Edit Profile Picture"
        btnConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            
            return outgoing
        }
        
        btnConfig.baseBackgroundColor = .blue
        btnConfig.baseForegroundColor = .systemIndigo
        btnConfig.cornerStyle = .capsule
        btnConfig.titlePadding = 24
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        editBtn.configuration = btnConfig
        
        hStack.axis = .vertical
        hStack.alignment = .center
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
    }
    
    private func setAvailableData(for user: Users?) {
        var img = UIImage(systemName: "person.crop.circle")
        label.text = "User"
        
        if let user = user {
            label.text = "\(user.firstName) \(user.lastName)"
            
            if let avatar = user.avatar,
               avatar != Empty.String,
               let parsedData = Data(base64Encoded: avatar) {
                img = UIImage(data: parsedData)
            }
        }
        
        imageView.image = img
        imageView.tintColor = .systemGray
    }
}
