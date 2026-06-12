//
//  PlotData.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 03/06/26.
//

import Foundation

internal struct PlotData: Codable {
    var id: Int32
    var weightId: Int32
    var type: String
    var x: Int
    var y: Int
    
    init(weightId: Int32, type: String, x: Int, y: Int) {
        self.weightId = weightId
        self.type = type
        self.x = x
        self.y = y
        self.id = 0
    }
}
