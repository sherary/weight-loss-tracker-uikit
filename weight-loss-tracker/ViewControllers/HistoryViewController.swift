//
//  HistoryViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class HistoryViewController: UIViewController {
    private var historyView: HistoryView { view as! HistoryView }
    
    override func loadView() {
        view = HistoryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [weak self] _ in
                self?.presentSheet()
            }
        )
        
        historyView.weightHistoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "WeightCell")
        historyView.weightHistoryTable.dataSource = self
        historyView.weightHistoryTable.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeDidChange),
            name: .weightStoreDidChange,
            object: nil
        )
    }
    
    @objc private func storeDidChange() {
        historyView.weightHistoryTable.reloadData()
    }
    
    private func presentSheet(weight: Weights? = nil) {
        let weightInputVC = WeightInputViewController()
        if let selectedData = weight {
            weightInputVC.availableData = weight
        }
        
        let nav = UINavigationController(rootViewController: weightInputVC)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "id_ID")

        return "\(date.formatted(.dateTime.weekday(.wide))) \(formatter.string(from: date))"
    }
}

extension HistoryViewController: UITableViewDataSource {
    // Set how many row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WeightStore.shared.collection.count
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a recycled cell (or get a fresh one if none to recycle)
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath)
        
        // Get data for THIS row
        let entry = WeightStore.shared.collection[indexPath.row]
        let nextEntry = WeightStore.shared.collection[indexPath.row == 0 ? indexPath.row : indexPath.row - 1]
        
        // Configure EVERY visible property - cell may have stale content
        var config = cell.defaultContentConfiguration()
        let imageConfig = setImage(remainder: nextEntry.weight - entry.weight)
        config.image = imageConfig.img
        config.imageProperties.tintColor = imageConfig.color
        
        config.text = "Weight: \(entry.weight) kg"
        config.secondaryText = formattedDate(entry.date)
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func setImage(remainder: Double) -> (img: UIImage?, color: UIColor) {
        var result: (img: UIImage?, color: UIColor) = (img: UIImage(systemName: "square.fill"), color: UIColor.systemBlue)
        
        if remainder < 0 {
            result = (img: UIImage(systemName: "arrowtriangle.up.fill"), color: UIColor.systemRed)
        } else if remainder > 0 {
            result = (img: UIImage(systemName: "arrowtriangle.down.fill"), color: UIColor.systemGreen)
        }
        
        return result
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {
            // (action, sourceView, completion) -> only need completion
            [weak self] _, _, completion in
            guard self != nil else {
                completion(false)
                
                return
            } // completion(bool) -> Swift version of next(bool)
            
            let entry = WeightStore.shared.collection[indexPath.row]
            WeightStore.shared.delete(id: entry.id)
            
            completion(true)
        }
        
        delete.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [delete]) // array, because one swipe could contain multiple
    }
}

extension HistoryViewController: UITableViewDelegate {
    // The user tapped a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = WeightStore.shared.collection[indexPath.row]
        
        presentSheet(weight: selectedItem)
    }
}
