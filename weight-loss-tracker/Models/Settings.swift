//
//  Settings.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 23/06/26.
//

import UIKit

internal struct SettingSection: Codable {
    var id: Int
    var title: String
    var items: [SettingItems]
    var description: String?
    
    init(sectionId: Int = 0, title: String, items: [SettingItems], description: String? = nil) {
        self.id = sectionId
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
