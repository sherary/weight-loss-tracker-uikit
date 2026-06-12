//
//  Legends.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 05/06/26.
//

import Foundation
import UIKit

internal struct Legends {
    var text: String
    var size: Double
    var color: UIColor
    var shape: String
    
    init(text: String, size: Double, color: UIColor, shape: String) {
        self.text = text
        self.size = size
        self.color = color
        self.shape = shape
    }
}
