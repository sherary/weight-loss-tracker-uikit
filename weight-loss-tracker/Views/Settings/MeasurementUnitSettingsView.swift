//
//  MeasurementUnitSettingsView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import UIKit

final class MeasurementUnitSettingsView: UIView {
    private var label = UILabel()
    internal var textCarousel = TextCarouselView()
    internal var saveBtn = UIButton()
    internal var onTappedToVC: ((Int) -> Void)?
    
    internal var setting: SettingItems? {
        didSet {
            if let setting = setting {
                label.text = setting.name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupLayout()
        textCarousel.onTapped = { [weak self] action in
            self?.onTappedToVC?(action)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .natural
        
        textCarousel.font = label.font
        
        let hStack = UIStackView(arrangedSubviews: [label, textCarousel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        var btnConfig = UIButton.Configuration.borderedProminent()
        btnConfig.title = "Save"
        btnConfig.baseBackgroundColor = .systemBlue
        btnConfig.baseForegroundColor = .white
        btnConfig.cornerStyle = .small
        btnConfig.titlePadding = label.font.pointSize / 2
        btnConfig.contentInsets = NSDirectionalEdgeInsets(
            top: btnConfig.titlePadding,
            leading: btnConfig.titlePadding,
            bottom: btnConfig.titlePadding,
            trailing: btnConfig.titlePadding
        )
        saveBtn.configuration = btnConfig
       
        let vStack = UIStackView(arrangedSubviews: [hStack, saveBtn])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.spacing = label.font.pointSize
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            textCarousel.widthAnchor.constraint(equalToConstant: vStack.spacing * 11),
            
            hStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
