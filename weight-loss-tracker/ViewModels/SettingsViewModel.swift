import Foundation

internal struct SettingsViewModel {
    internal func measurementUnitParser(_ unit: Int) -> String {
        var result: String = Empty.String
        
        for (index, item) in MeasurementUnits.allCases.enumerated() {
            if index == unit {
                let data = item.rawValue
                result = "\(data.prefix(1).uppercased())\(data.suffix(data.count - 1))"
            }
        }
        
        return result
    }
    
    internal func activityLevelParser(_ level: Int) -> String {
        return SettingsService.shared.activityLevels[level]
    }
    
    internal func weightParser(_ weight: Double) -> (number: Double, unit: String)? {
        var result: (number: Double, unit: String) = (number: 0, unit: Empty.String)
        let unit = Settings.measurementUnit
        let weight = Settings.goalWeight
        
        result.number = weight
        result.unit = Int(unit) == MeasurementUnits.metric.index ? "kg" : "lbs"

        UserDefaults.standard.removeObject(forKey: "measurementChanged")
        
        return result
    }
    
    internal func parseWeight(to type: Int, weight: Double) -> Double {
        var parsedWeight: Double = 0
        
        switch type {
        case MeasurementUnits.metric.index:
            parsedWeight = Double(weight) / 2.20462
        case MeasurementUnits.imperial.index:
            parsedWeight = Double(weight) * 2.20462
        default:
            return parsedWeight
        }
        
        return parsedWeight
    }
    
    internal func dateRangeParser(_ num: Int) -> String {
        let days: [String] = DayNames
        var endIndex = num - 1
        if endIndex < 0 {
            endIndex = days.count - 1
        }
        
        return "\(days[num]) - \(days[endIndex])"
    }
    
    internal func monthlyRangeParser(_ day: Int) -> String {
        var result = "Start at \(day)"
        
        switch day {
        case 1, 21, 31:
            result += "st"
        case 2, 22:
            result += "nd"
        case 3:
            result += "rd"
        default:
            result += "th"
        }
        
        return result
    }
    
    internal func valueHandlerById(for id: String, with value: SettingValue) -> String {
        switch id {
        case SettingKey.goalWeight.name:
            guard let doubleValue = value.doubleValue,
                  let weight = weightParser(doubleValue)
            else {
                return "\(value) kg"
            }
            
            return "\(Int(weight.number)) \(weight.unit)"
        case SettingKey.activityLevel.name:
            guard let intValue = value.intValue else { return Empty.String }
            
            return activityLevelParser(intValue)
        case SettingKey.measurement.name:
            guard let intValue = value.intValue else { return Empty.String }
            
            return measurementUnitParser(intValue)
        case SettingKey.dayStart.name:
            guard let intValue = value.intValue else { return Empty.String }
            
            return dateRangeParser(intValue)
        case SettingKey.monthStart.name:
            guard let intValue = value.intValue else { return Empty.String }
            
            return monthlyRangeParser(intValue)
        case SettingKey.appleWatchConnect.name, SettingKey.miBandConnect.name:
            guard let intValue = value.intValue else { return Empty.String }
            
            return intValue == 0 ? "Not Connected" : "Connected"
        default:
            return "\(value)"
        }
    }
    
    internal func getUserInfo() -> Users {
        return Users(
            firstName: Settings.firstName,
            lastName: Settings.lastName,
            height: Double(Settings.height),
            gender: Settings.gender
        )
    }
}
