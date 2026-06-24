//
//  Users.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 27/05/26.
//

import Foundation

internal struct MutableInfo: Codable {
    var id: Int
    var age: Int
    var activityLevel: String
    var weight: Double
    var tdee: Double
    var bmr: Double
    
    init(age: Int, activityLevel: String, weight: Double, tdee: Double, bmr: Double) {
        self.age = age
        self.activityLevel = activityLevel
        self.weight = weight
        self.tdee = tdee
        self.bmr = bmr
        self.id = 0
    }
}

internal struct Users: Codable {
    var id: UUID?
    var firstName: String
    var lastName: String
    var height: Double
    var sex: String
    var avatar: String?
    var mutableInfo: MutableInfo?
    
    init(firstName: String, lastName: String, height: Double, sex: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.sex = sex
    }
}
