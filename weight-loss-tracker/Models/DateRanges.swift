//
//  DateRanges.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 18/06/26.
//

import Foundation

internal struct DateRanges {
    var type: Int
    var value: Int
    var startDate: Date
    var endDate: Date
    
    init(type: Int = CalendarType.weekly.rawValue, value: Int = 0, startDate: Date = Date.now, endDate: Date = Date.now) {
        self.type = type
        self.value = value
        self.startDate = startDate
        self.endDate = endDate
    }
}
