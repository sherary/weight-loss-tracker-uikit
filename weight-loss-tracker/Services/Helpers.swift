//
//  Helpers.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 08/06/26.
//
import UIKit

final class Helpers {
    static let shared = Helpers()
    private static var formatter = Date.localFormatter
    private static let calendar = Calendar.local
    private static let localComponent = DateComponents.local
    
    internal static func getDayOfDate(date: Date) -> String? {
        formatter.dateFormat = "EEE"
        
        return formatter.string(from: date)
    }
    
    internal static func getDaysOfWholeWeek(startDate: Date) -> [String] {
        formatter.dateFormat = "EEE"
        
        let endDate = startDate.addingTimeInterval(86400 * 7)
        
        var days: [String] = []
        for date in stride(from: startDate, to: endDate, by: 86400) {
            days.append(formatter.string(from: date))
        }
        
        return days
    }
    
    internal static func getMonthString(date: Date) -> String {
        formatter.dateFormat = "MMMM"
        
        return formatter.string(from: date)
    }
    
    internal static func getMonthString(index: Int) -> String {
        return calendar.monthSymbols[index - 1]
    }
    
    internal static func getWholeWeeksByDates(dates: [Date]) -> [String] {
        var result: [String] = []
        for date in dates {
            guard let day = self.getDayOfDate(date: date) else { continue }
            result.append(day)
        }
        
        return result
    }
    
    internal static func getDayOfWeekIndex(date: Date) -> Int {
        return calendar.component(.weekday, from: date)
    }
    
    internal static func getWeekOfMonthIndex(date: Date) -> Int {
        return calendar.component(.weekOfMonth, from: date)
    }
    
    internal static func getDateRanges(from components: DateComponents, type: Int = 0) -> DateRanges? {
        var dateRanges = DateRanges()
        
        switch type {
        case 0:
            guard let weekIndex = components.weekOfMonth,
                  let startDate = Helpers.getFirstDayOfWeek(weekIndex: weekIndex, in: components),
                  let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)
            else { return nil }
            
            dateRanges = DateRanges(type: type, value: weekIndex, startDate: startDate, endDate: endDate)
        case 1:
            guard let monthIndex = components.month,
                  let year = components.year,
                  let startDate = Helpers.composeDate(year: year, month: monthIndex, date: 1)
            else { return nil }
            
            let dateCount = Helpers.getLastDateOfMonth(for: startDate)
            guard let endDate = Calendar.current.date(byAdding: .day, value: dateCount, to: startDate) else { return nil }
            
            dateRanges = DateRanges(type: type, value: monthIndex, startDate: startDate, endDate: endDate)
        case 2:
            guard let year = components.year,
                  let startDate = Helpers.composeDate(year: year, month: 1, date: 1),
                  let endDate = Helpers.composeDate(year: year, month: 12, date: 31)
            else { return nil }
            
            dateRanges = DateRanges(type: type, value: year, startDate: startDate, endDate: endDate)
        default:
            break
        }
        
        return dateRanges
    }
    
    internal static func getFirstDayOfWeek(weekIndex: Int, in component: DateComponents) -> Date? {
        var targetComponents = self.localComponent
        targetComponents.year = component.year
        targetComponents.month = component.month
        targetComponents.weekOfMonth = weekIndex
        targetComponents.weekday = Calendar.current.firstWeekday
        
        return calendar.date(from: targetComponents)
    }
    
    internal static func composeDate(year: Int, month: Int, date: Int) -> Date? {
        var components = self.localComponent
        components.year = year
        components.month = month
        components.day = date
        components.timeZone = TimeZone.current
        
        return calendar.date(from: components)
    }
    
    internal static func getLastDateOfMonth(for date: Date) -> Int {
        guard let dayRange = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        return dayRange.count
    }
    
    internal static func getComponentsFrom(from date: Date, components: Set<Calendar.Component>) -> DateComponents {
        return calendar.dateComponents(components, from: date)
    }
    
    internal static func getTotalWeeksInMonth(from date: Date) -> Int {
        if let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: date) {
            return weekRange.count
        }
        
        return 0
    }
    
    internal static func getDateRanges(from components: DateComponents, type: Int = 0) -> DateRanges? {
        var dateRanges = DateRanges()
        
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
