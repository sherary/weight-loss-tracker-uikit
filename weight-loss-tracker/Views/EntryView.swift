//
//  EntryView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import UIKit

final class EntryView: UIView {
    internal var chartView = WeightChartView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.layer.cornerRadius = 10
        chartView.clipsToBounds = true
        chartView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 20)
        
        self.addSubview(chartView)
        self.backgroundColor = .secondarySystemBackground
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
