//
//  ActivityLevelSettingsView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import UIKit

final class ActivityLevelSettingsView: UIView {
    private var label = UILabel()
    private var appliedInitialChanges = false
    
    internal var pickerView = UIPickerView()
    internal var saveBtn = UIButton()
    
    internal var setting: SettingItems? {
        didSet {
            label.text = setting?.name
            appliedInitialChanges = false
            
            setInitialSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setInitialSelection()
    }
    
    private func setInitialSelection() {
        guard !appliedInitialChanges,
              let data = setting,
              bounds.width > 0
        else { return }
        
        pickerView.selectRow(data.value, inComponent: 0, animated: false)
        appliedInitialChanges = true
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
        
        let vStack = UIStackView(arrangedSubviews: [label, pickerView, saveBtn])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.spacing = 0
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
