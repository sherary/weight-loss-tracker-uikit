//
//  SettingsController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import Foundation

final class SettingsService {
    static let shared = SettingsService()
    private(set) var activityLevels: [String] = []
    
    private init() {
        load()
    }
    
    private func load() {
        getActivityLevelsName()
    }
    
    private func getActivityLevelsName() {
        activityLevels.removeAll()
        
        for (_, item) in ActivityLevels.allCases.enumerated() {
            activityLevels.append(item.name)
        }
    }
    
    internal static func activityLevelParser(_ level: Int) -> String {
        return SettingsService.shared.activityLevels[level]
    }
    
    internal static func getSettingSection(for sectionId: Int, and settingId: Int) -> SettingSection? {
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY),
              let decodedData = try? JSONDecoder().decode([SettingSection].self, from: data),
              var settingSection = decodedData.first(where: { $0.id == sectionId })
        else { return nil }
        
        settingSection.items = settingSection.items.filter({ $0.id == settingId })
        
        return settingSection
    }
    
    internal static func getAvailableSettings() -> [SettingSection] {
        guard let data = UserDefaults.standard.data(forKey: Configs.SETTINGS_KEY) else { return [] }
        guard let decodedData = try? JSONDecoder().decode([SettingSection].self, from: data) else { return [] }
        
        return decodedData
    }
    
    
}
