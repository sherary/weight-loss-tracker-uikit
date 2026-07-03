//
//  WeightGoalSettingsView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 24/06/26.
//

import UIKit

final class WeightGoalSettingsView: UIView {
    private let label = UILabel()
    internal let textField = UITextField()
    internal var saveBtn = UIButton()
    
    internal var setting: SettingItems? {
        didSet {
            guard let data = setting else { return }
            textField.text = "\(data.value)"
            label.text = data.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .natural
        label.text = setting?.name ?? "Goal Weight"
        
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .label
        textField.textAlignment = .left
        textField.placeholder = "48"
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.setSymbol(with: "kg", on: [.right])
        
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
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),
            vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}
