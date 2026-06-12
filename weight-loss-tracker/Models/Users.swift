//
//  Users.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import Foundation

internal struct Users: Codable {
    var id: UUID
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var sex: String
    var activityLevel: String
    var tdee: Double
    var bmr: Double
    
    init(name: String, age: Int, height: Double, weight: Double, sex: String, activityLevel: String, tdee: Double, bmr: Double) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.sex = sex
        self.activityLevel = activityLevel
        self.tdee = tdee
        self.bmr = bmr
        self.id = UUID()
    }
}
