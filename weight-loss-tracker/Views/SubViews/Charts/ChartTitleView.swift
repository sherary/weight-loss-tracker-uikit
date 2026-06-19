//
//  ChartTitleView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/06/26.
//

import UIKit

internal class ChartTitleView: UIView {
    internal var title: String = "Chart Title" {
        didSet {
            lblTitle.text = self.title
        }
    }
    
    internal var subTitle: String = "Chart Subtitle" {
        didSet {
            lblSubTitle.text = self.subTitle
        }
    }
    
    private let lblTitle: UILabel = UILabel()
    private let lblSubTitle: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setLayout() {
        lblSubTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lblSubTitle.textColor = .tertiaryLabel
        lblSubTitle.translatesAutoresizingMaskIntoConstraints = false
        
        lblTitle.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        lblTitle.textColor = .label
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack: UIStackView = UIStackView(arrangedSubviews: [lblSubTitle, lblTitle])
        hStack.axis = .vertical
        hStack.alignment = .leading
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
