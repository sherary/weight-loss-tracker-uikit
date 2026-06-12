//
//  ChartLegendsView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/06/26.
//

import UIKit

internal class ChartLegendsView: UIView {
    internal var items: [Legends] = [] {
        didSet {
            rebuild()
        }
    }
    
    private let stackView: UIStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupStack() {
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
    
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func rebuild() {
        for item in items {
            let config = UIImage.SymbolConfiguration(weight: .black)
                
            let symbol: UIImageView = UIImageView(image: UIImage(systemName: item.shape, withConfiguration: config))
            symbol.tintColor = item.color
            symbol.backgroundColor = .clear
            symbol.contentMode = .scaleToFill
            symbol.translatesAutoresizingMaskIntoConstraints = false
            symbol.widthAnchor.constraint(equalToConstant: item.size - 2).isActive = true
            symbol.heightAnchor.constraint(equalToConstant: item.size - 2).isActive = true
                
            let label: UILabel = UILabel()
            label.text = item.text
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: item.size, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
                
            stackView.addArrangedSubview(symbol)
            stackView.addArrangedSubview(label)
        }
    }
}
