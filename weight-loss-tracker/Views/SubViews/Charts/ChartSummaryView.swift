//
//  ChartSummaryView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 11/06/26.
//

import UIKit

final class ChartSummaryView: UIView {
    private lazy var totalLbl: UILabel = UILabel()
    private lazy var averageLbl: UILabel = UILabel()
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [totalLbl, averageLbl])
    
    internal var weights: [Double] = [] {
        didSet {
            calculateSummary(weights)
            rebuild()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func calculateSummary(_ data: [Double]) {
        if data.count < 1 { return }
        
        let total = data.reduce(0, +)
        let avg = total / Double(data.count)
        
        totalLbl.text = "Total: \(round(total * 100) / 100)"
        averageLbl.text = "Average: \(round(avg * 100) / 100)"
    }
    
    private func rebuild() {
        totalLbl.font = .boldSystemFont(ofSize: 12)
        totalLbl.textAlignment = .left
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        
        averageLbl.font = .boldSystemFont(ofSize: 10)
        averageLbl.textAlignment = .left
        averageLbl.translatesAutoresizingMaskIntoConstraints = false
    }
 
    private func setupStack() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
