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
