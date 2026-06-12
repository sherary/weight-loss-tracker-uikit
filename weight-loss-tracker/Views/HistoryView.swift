//
//  HistoryView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class HistoryView: UIView {
    internal let weightHistoryTable: UITableView = UITableView(frame: .zero, style: .plain)
    internal let addButtonItem: UIBarButtonItem = UIBarButtonItem()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.backgroundColor = .systemBackground
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)

        weightHistoryTable.translatesAutoresizingMaskIntoConstraints = false
        weightHistoryTable.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        self.addSubview(weightHistoryTable)
        
        NSLayoutConstraint.activate([
            weightHistoryTable.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            weightHistoryTable.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            weightHistoryTable.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            weightHistoryTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
