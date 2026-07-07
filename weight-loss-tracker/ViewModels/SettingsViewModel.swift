//
//  MeasurementUnitsViewModel.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 07/07/26.
//

internal struct SettingsViewModel {
    internal func measurementUnitParser(_ unit: Int) -> String {
        var result: String = ""
        
        for (index, item) in MeasurementUnits.allCases.enumerated() {
            if index == unit {
                let data = item.rawValue
                result = "\(data.prefix(1).uppercased())\(data.suffix(data.count - 1))"
            }
        }
        
        return result
    }
    
    internal static func activityLevelParser(_ level: Int) -> String {
        return SettingsService.shared.activityLevels[level]
    }
}
