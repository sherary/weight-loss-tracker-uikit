//
//  Helpers.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 08/06/26.
//
import UIKit

final class Helpers {
    static let shared = Helpers()
    
    internal static func getDayOfDate(date: Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        return formatter.string(from: date)
    }
    
    internal static func getDaysOfWholeWeek(startDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        
        let endDate = startDate.addingTimeInterval(86400 * 7)
        
        var days: [String] = []
        for date in stride(from: startDate, to: endDate, by: 86400) {
            days.append(formatter.string(from: date))
        }
        
        return days
    }
    
    internal static func getMonthString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: date)
    }
    
    internal static func getMonthString(index: Int) -> String {
        return Calendar.current.monthSymbols[index - 1]
    }
    
    internal static func getWholeWeeksByDates(dates: [Date]) -> [String] {
        var result: [String] = []
        for date in dates {
            result.append(self.getDayOfDate(date: date)!)
        }
        
        return result
    }
    
    internal static func getDayOfWeekIndex(date: Date) -> Int {
        return Calendar.current.component(.weekday, from: date)
    }
    
    internal static func getWeekOfMonthIndex(date: Date) -> Int {
        return Calendar.current.component(.weekOfMonth, from: date)
    }
    
    internal static func getDateRange(from components: DateComponents, type: Int = 0) -> DateRanges? {
        guard let weekIndex = components.weekOfMonth,
            let startDate = Helpers.getFirstDayOfWeek(weekIndex: weekIndex, in: components) else { return nil }
        
        var valueToAdd: Int = 0
        var addingComponents = Calendar.Component.day
        var value: Int = 0
        
        switch type {
        case 0:
            valueToAdd = 6
            value = weekIndex
        case 1:
            valueToAdd = 1
            addingComponents = Calendar.Component.month
            
            guard let month = components.month else { return nil }
            
            value = month
        case 2:
            valueToAdd = 1
            addingComponents = Calendar.Component.year
            guard let year = components.year else { return nil }
            
            value = year
        default:
            break
        }
        
        guard let endDate = Calendar.current.date(byAdding: addingComponents, value: valueToAdd, to: startDate) else { return nil }
        
        return DateRanges(type: type, value: value, startDate: startDate, endDate: endDate)
    }
    
    internal static func getFirstDayOfWeek(weekIndex: Int, in component: DateComponents) -> Date? {
        var targetComponents = DateComponents()
        targetComponents.year = component.year
        targetComponents.month = component.month
        targetComponents.weekOfMonth = weekIndex
        targetComponents.weekday = Calendar.current.firstWeekday
        
        return Calendar.current.date(from: targetComponents)
    }
    
    internal static func composeDate(year: Int, month: Int, date: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = date
        components.timeZone = TimeZone.current
        
        return Calendar.current.date(from: components)!
    }
    
    internal static func getComponentsFrom(from date: Date, components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: date)
    }
    
    internal static func getTotalWeeksInMonth(from date: Date) -> Int {
        if let weekRange = Calendar.current.range(of: .weekOfMonth, in: .month, for: date) {
            return weekRange.count
        }
        
        return 0
    }
    
    internal static func removeExcessiveCommas(text: String) -> String {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var result = ""
        
        for char in normalized {
            if char == "," {
                guard !result.contains(",") else { continue }
                
                result.append(",")
            } else {
                result.append(char)
            }
        }
        
        return result
    }
}
