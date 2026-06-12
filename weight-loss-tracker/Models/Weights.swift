//
//  Weights.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import Foundation

internal struct Weights: Codable {
    var id: Int32
    var date: Date
    var weight: Double
    var stepCount: Int32
    var calorieBurned: Int32
    var remainder: Double 
    
    init(date: Date, weight: Double, stepCount: Int32, calorieBurned: Int32) {
        self.date = date
        self.weight = weight
        self.stepCount = stepCount
        self.calorieBurned = calorieBurned
        self.id = 0
        self.remainder = 0.0
    }
}
