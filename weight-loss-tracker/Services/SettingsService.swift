//
//  SettingsController.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 25/06/26.
//

import Foundation

final class SettingsService {
    internal static let shared = SettingsService()
    
    private(set) var activityLevels: [String] = []
    private(set) var dayNames: [String] = DayNames
    
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
    
    internal static func getSetting(for settingId: String) -> SettingItems? {
        let settings: [SettingItems] = Settings.generalItems
        
        return settings.first(where: { $0.id == settingId })
    }
    
    internal static func getAvailableSettings() -> [SettingSection] {
        let settings: [SettingSection] = [
            SettingSection(
                sectionId: 1,
                title: "Preferences",
                items: [
                    SettingItems(
                        id: SettingKey.goalWeight.name,
                        name: SettingKey.goalWeight.title,
                        value: .double(Settings.goalWeight),
                        destination: .goalWeight
                    ),
                    SettingItems(
                        id: SettingKey.activityLevel.name,
                        name: SettingKey.activityLevel.title,
                        value: .int(Settings.activityLevel),
                        destination: .activityLevel
                    ),
                    SettingItems(
                        id: SettingKey.measurement.name,
                        name: SettingKey.measurement.title,
                        value: .int(Settings.measurementUnit),
                        destination: .measurement
                    )
                ],
                description: "Set your preferences on weight goals, activity level and measurement units"
            ),
            SettingSection(
                sectionId: 2,
                title: "Dates",
                items: [
                    SettingItems(
                        id: SettingKey.dayStart.name,
                        name: SettingKey.dayStart.title,
                        value: .int(Settings.dayStart),
                        destination: .dayStart
                    ),
                    SettingItems(
                        id: SettingKey.monthStart.name,
                        name: SettingKey.monthStart.title,
                        value: .int(Settings.monthStart),
                        destination: .monthStart
                    ),
                ],
                description: "Set your starting day of the week and preferable starting date each month"
            ),
            
            SettingSection(
                sectionId: 3,
                title: "Connections",
                items: [
                    SettingItems(
                        id: SettingKey.appleWatchConnect.name,
                        name: SettingKey.appleWatchConnect.title,
                        value: .bool(Settings.appleWatchConnect),
                        destination: .appleWatchConnect
                    ),
                    SettingItems(
                        id: SettingKey.miBandConnect.name,
                        name: SettingKey.miBandConnect.title,
                        value: .bool(Settings.miBandConnect),
                        destination: .miBandConnect
                    ),
                ],
                description: "Connect your available devices"
            ),
        ]
        
        return settings
    }
}
