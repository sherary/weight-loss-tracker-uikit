//
//  UserAvatar.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 22/06/26.
//

import UIKit

final class UserAvatarView: UIView {
    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    
    internal var user: Users? {
        didSet {
            guard let availableUserData = user else { return }
            
            self.setAvailableData(for: availableUserData)
            self.setupLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        setAvailableData(for: user)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }
    
    private func setAvailableData(for user: Users?) {
        if let userName = user?.firstName {
            label.text = userName
        } else {
            label.text = "User"
        }
        
        var img = UIImage(systemName: "person.crop.circle")
        if let userAvatar = user?.avatar, let imgData = Data(base64Encoded: userAvatar) {
            img = UIImage(data: imgData)
        }
        
        imageView.image = img
        imageView.tintColor = .systemCyan
    }
    
    private func setupLayout() {
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack: UIStackView = UIStackView(arrangedSubviews: [imageView, label])
        hStack.axis = .vertical
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageView.frame.width),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            hStack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            self.heightAnchor.constraint(equalToConstant: imageView.frame.height * 2),
            self.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ])
    }
}
