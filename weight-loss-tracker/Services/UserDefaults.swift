//
//  UserDefaults.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/05/26.
//

import Foundation

class CollectionTypeUserDefaultMethods {
    private static let defaults = UserDefaults.standard
    
    internal static func loadUserDefaultCustomObject(key: String) -> [Weights] {
        guard let data = defaults.data(forKey: key) else {
            return []
        }
        
        guard let decodedData = try? JSONDecoder().decode([Weights].self, from: data) else {
            return []
        }
        
        return decodedData
    }

    internal static func saveCustomObjectAsUserDefault(as key: String, data: [Weights]) {
        guard let data = try? JSONEncoder().encode(data) else { return }
        
        defaults.set(data, forKey: key)
    }
    
    internal static func editObjectById(key: String, data: Weights) {
        var collection: [Weights] = self.loadUserDefaultCustomObject(key: Configs.USER_DEFAULTS_KEY)
        
        guard let index = collection.firstIndex(where: { $0.id == data.id }) else {
            return
        }
        
        collection[index] = data
        
        self.saveCustomObjectAsUserDefault(as: key, data: collection)
    }
    
    internal static func purgeUserDefaults(key: String) {
        defaults.removeObject(forKey: key)
    }
    
    internal static func deleteObjectById(key: String, id: Int32) {
        var collection: [Weights] = self.loadUserDefaultCustomObject(key: Configs.USER_DEFAULTS_KEY)
        
        guard let index = collection.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        collection.remove(at: index)
        self.saveCustomObjectAsUserDefault(as: key, data: collection)
    }
}
