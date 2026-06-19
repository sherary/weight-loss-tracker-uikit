//
//  HistoryView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class HistoryView: UIView {
    private let padding: CGFloat = 8
    
    internal let weightHistoryTable: UITableView = UITableView(frame: .zero, style: .plain)
    internal let addButtonItem: UIBarButtonItem = UIBarButtonItem()
    internal let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Weeks", "Months", "Year"])
    internal var onTappedToVC: ((Int) -> Void)?
    
    private lazy var titleLbl: TextCarouselView = TextCarouselView()
    
    internal var text: String = "Title" {
        didSet {
            titleLbl.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        titleLbl.onTapped = { [weak self] action in
            self?.onTappedToVC?(action)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.backgroundColor = .systemBackground
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        weightHistoryTable.translatesAutoresizingMaskIntoConstraints = false
        weightHistoryTable.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        addSubview(segmentedControl)
        addSubview(titleLbl)
        addSubview(weightHistoryTable)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: padding),
            titleLbl.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            weightHistoryTable.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: padding),
            weightHistoryTable.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            weightHistoryTable.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            weightHistoryTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
