//
//  TextCarouselView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 17/06/26.
//

import UIKit

final class TextCarouselView: UIView {
    private lazy var label: UILabel = UILabel()
    private lazy var backBtn: UIButton = UIButton()
    private lazy var forwardBtn: UIButton = UIButton()
    private struct Tap {
        static let back: Int = -1
        static let forward: Int = 1
    }
    
    internal var onTapped: ((Int) -> Void)?
    
    internal var text: String = "Week 0" {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        backBtn.addAction(UIAction { [weak self] _ in
            self?.onTapped?(Tap.back)
        }, for: .touchUpInside)
        
        forwardBtn.addAction(UIAction { [weak self] _ in
            self?.onTapped?(Tap.forward)
        }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.left")
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: label.font.pointSize, weight: .medium)
              
        backBtn.configuration = config
        
        config.image = UIImage(systemName: "chevron.right")
        forwardBtn.configuration = config
        
        label.text = "Week 0"
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        
        let hStack: UIStackView = UIStackView(arrangedSubviews: [backBtn, label, forwardBtn])
        hStack.axis = .horizontal
        hStack.spacing = 4
        hStack.distribution = .fillProportionally
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: label.font.pointSize),
            backBtn.heightAnchor.constraint(equalToConstant: label.font.pointSize),
            
            forwardBtn.widthAnchor.constraint(equalToConstant: label.font.pointSize),
            forwardBtn.heightAnchor.constraint(equalToConstant: label.font.pointSize),
            
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
