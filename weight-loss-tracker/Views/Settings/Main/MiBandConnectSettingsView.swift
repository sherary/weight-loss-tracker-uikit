//
//  MiBandConnectSettingsView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/07/26.
//

import UIKit

final class MiBandConnectSettingsView: UIView {
    private var label = UILabel()
    
    internal var switchView = UISwitch()
    internal var saveBtn = UIButton()
    
    internal var setting: SettingItems? {
        didSet {
            guard let setting = setting,
                  let isOn = setting.value.boolValue
            else { return }
            
            label.text = setting.name
            switchView.isOn = isOn
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
        
        var btnConfig = UIButton.Configuration.borderedProminent()
        btnConfig.title = "Save"
        btnConfig.baseBackgroundColor = .systemBlue
        btnConfig.baseForegroundColor = .white
        btnConfig.cornerStyle = .small
        btnConfig.titlePadding = 8
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        saveBtn.configuration = btnConfig
        
        let vStack = UIStackView(arrangedSubviews: [label, switchView, saveBtn])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
