//
//  Settings.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 23/06/26.
//

internal struct SettingSection: Codable {
    var title: String
    var items: [SettingItems]
    var description: String?
    
    init(title: String, items: [SettingItems], description: String? = nil) {
        self.title = title
        self.items = items
        self.description = description
    }
}

internal struct SettingItems: Codable {
    var id: Int
    var name: String
    var value: Int
    var destination: Destination
    
    init(id: Int = 0, name: String, value: Int, destination: Destination) {
        self.id = id
        self.name = name
        self.value = value
        self.destination = destination
    }
}
