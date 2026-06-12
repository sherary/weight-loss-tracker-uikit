//
//  WeightStores.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 28/05/26.
//

import UIKit
// if shits happen, delete self 
final class WeightStore {
    static let shared = WeightStore()
    private(set) var collection: [Weights] = []
    private let key = Configs.USER_DEFAULTS_KEY
    
    private init() {
        load()
    }
    
    private func load() {
        self.collection = CollectionTypeUserDefaultMethods.loadUserDefaultCustomObject(key: key)
        self.collection.sort { $0.date < $1.date }
    }
    
    func add(_ data: Weights) {
        var newEntry = data
        newEntry.id = nextID()
        
        self.collection.append(newEntry)
        self.sortAndPersist()
        self.notifyChange()
    }
    
    func update(_ data: Weights) {
        guard let index = collection.firstIndex(where: { $0.id == data.id }) else { return }
        self.collection[index] = data
        
        self.sortAndPersist()
        self.notifyChange()
    }
    
    func delete(id: Int32) {
        self.collection.removeAll { $0.id == id }
        
        self.sortAndPersist()
        self.notifyChange()
    }
    
    func upsertByDate(weight: Double, date: Date) {
        if let existing = collection.first(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            var availableData = existing
            availableData.weight = weight
            
            self.update(availableData)
        } else {
            self.add(Weights(date: date, weight: weight, stepCount: 0, calorieBurned: 0))
        }
    }
    
    private func nextID () -> Int32 {
        (self.collection.map { $0.id }.max() ?? 0) + 1
    }
    
    private func sortAndPersist() {
        self.collection.sort { $0.date < $1.date }
        CollectionTypeUserDefaultMethods.saveCustomObjectAsUserDefault(as: key, data: self.collection)
    }
    
    private func notifyChange() {
        NotificationCenter.default.post(name: .weightStoreDidChange, object: nil)
    }
}

extension Notification.Name {
    static let weightStoreDidChange = Notification.Name("weightStoreDidChange")
}
