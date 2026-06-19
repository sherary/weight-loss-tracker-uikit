//
//  HistoryViewController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class HistoryViewController: UIViewController {
    private let historyView = HistoryView()
    private var dateRanges = DateRanges() {
        didSet {
            guard dateRanges.startDate < dateRanges.endDate else { return }
            
            let data = WeightStore.shared.collection
            if let entries = self.reDelegateDataSource(from: data, matching: dateRanges) {
                self.entries = entries
            }
        }
    }
    private var components = DateComponents()
    private var entries: [Weights] = [] {
        didSet {
            historyView.weightHistoryTable.reloadData()
        }
    }
    
    private var displayDate: Date = Date.now {
        didSet {
            self.dissectDates(date: displayDate, target: &components)
        }
    }
    
    override func loadView() {
        self.view = historyView
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
        
        displayDate = Date.now
        
        historyView.segmentedControl.selectedSegmentIndex = 0
        self.handleSegment(at: historyView.segmentedControl.selectedSegmentIndex, date: &self.components)
        
        historyView.segmentedControl.addAction(UIAction { [weak self] action in
            guard let sender = action.sender as? UISegmentedControl,
                var dateComponent = self?.components else { return }
            self?.handleSegment(at: sender.selectedSegmentIndex, date: &dateComponent)
            self?.components = dateComponent
            self?.setDateRanges(for: dateComponent, at: sender.selectedSegmentIndex)
        }, for: .valueChanged)
        historyView.onTappedToVC = { [weak self] action in
            guard let index = self?.historyView.segmentedControl.selectedSegmentIndex,
                var dateComponent = self?.components else { return }
            self?.handleSegment(at: index, date: &dateComponent, action: action)
            self?.components = dateComponent
            self?.setDateRanges(for: dateComponent, at: index)
        }
    }
    
    @objc private func storeDidChange() {
        historyView.weightHistoryTable.reloadData()
    }
    
    private func dissectDates(date: Date, target targetDate: inout DateComponents) {
        targetDate = Helpers.getComponentsFrom(from: date, components: [.year, .month, .day, .weekOfYear, .weekOfMonth, .weekday])
    }
    
    private func setDateRanges(for dateComponent: DateComponents, at segmentIndex: Int = 0) {
        switch segmentIndex {
        case 0:
            guard let week = dateComponent.weekOfMonth else { return }
            
            self.dateRanges.type = CalendarType.weekly.rawValue
            self.dateRanges.value = week
        case 1:
            guard let month = dateComponent.month else { return }
            
            self.dateRanges.type = CalendarType.monthly.rawValue
            self.dateRanges.value = month
        case 2:
            guard let year = dateComponent.year else { return }
            
            self.dateRanges.type = CalendarType.yearly.rawValue
            self.dateRanges.value = year
        default:
            break
        }
        
        guard let dateRange = Helpers.getDateRange(from: dateComponent, type: dateRanges.type) else { return }
        self.dateRanges.startDate = dateRange.startDate
        self.dateRanges.endDate = dateRange.endDate
    }
    
    private func handleSegment(at index: Int, date dateComponents: inout DateComponents, action: Int = 0) {
        guard var week = dateComponents.weekOfMonth,
              var month = dateComponents.month,
              var year = dateComponents.year else { return }
        
        guard let date = Calendar.current.date(from: dateComponents) else { return }
        
        switch index {
        case 0:
            week += action
            let max = Helpers.getTotalWeeksInMonth(from: date)
            
            if week > max {
                month += action
                week = 1
            }
            
            if week < 1 {
                month += action
                week = Helpers.getTotalWeeksInMonth(from: date)
            }
            
            let monthName = Helpers.getMonthString(index: month)
            
            historyView.text = "\(monthName) Week \(week)"
        case 1:
            month += action
            if month < 1 {
                year -= 1
                month = 12
            }
            
            if month > 12 {
                year += 1
                month = 1
            }
            
            let monthName = Helpers.getMonthString(index: month)
            
            historyView.text = "\(monthName) \(year)"
        case 2:
            year += action
            
            historyView.text = "\(year)"
        default:
            break
        }
        
        dateComponents.weekOfMonth = week
        dateComponents.month = month
        dateComponents.year = year
    }
    
    private func reDelegateDataSource(from data: [Weights], matching ranges: DateRanges) -> [Weights]? {
        guard !data.isEmpty, ranges.startDate > Date.distantPast, ranges.endDate < Date.distantFuture else { return nil }
        
        let lowerBound = Calendar.current.startOfDay(for: ranges.startDate)
        let startOfEndDay = Calendar.current.startOfDay(for: ranges.endDate)
        guard let upperBound = Calendar.current.date(byAdding: .init(day: 1, second: -1), to: startOfEndDay) else {
            return nil
        }
        
        let dateRange = lowerBound...upperBound

        return data.filter { item in
            dateRange.contains(item.date)
        }
    }
    
    private func presentSheet(weight: Weights? = nil) {
        let weightInputVC = WeightInputViewController()
        if let selectedData = weight {
            weightInputVC.availableData = selectedData
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
        return self.entries.count
    }
    
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a recycled cell (or get a fresh one if none to recycle)
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightCell", for: indexPath)
        
        // Get data for THIS row
        let entry = self.entries[indexPath.row]
        let nextEntry = self.entries[indexPath.row == 0 ? indexPath.row : indexPath.row - 1]
        
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
            
            guard let entry = self?.entries[indexPath.row] else { return }
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
        
        let selectedItem = self.entries[indexPath.row]
        
        presentSheet(weight: selectedItem)
    }
}
