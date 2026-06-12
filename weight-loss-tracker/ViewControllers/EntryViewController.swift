//
//  EntryViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import UIKit

final class EntryViewController: UIViewController {
    private var entryView: EntryView { view as! EntryView }
    
    override func loadView() {
        view = EntryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [weak self] _ in
                self?.presentSheet()
            }
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeDidChange),
            name: .weightStoreDidChange,
            object: nil
        )
        
        entryView.chartView.collection = WeightStore.shared.collection
        entryView.chartView.title = "1 - 7 June"
        entryView.chartView.subTitle = "Weekly Weight Trends"
    }
    
    @objc private func storeDidChange() {
        entryView.chartView.collection = WeightStore.shared.collection
    }
    
    private func presentSheet() {
        let weightInputVC = WeightInputViewController()
        let nav = UINavigationController(rootViewController: weightInputVC)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
}
