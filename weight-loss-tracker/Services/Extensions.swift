//
//  Extensions.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 07/06/26.
//

import UIKit

extension UIView {
    internal func addDashBorder(edges: [UIRectEdge], color: UIColor = .separator, thickness: CGFloat = 1, pattern: [NSNumber] = BorderStyles.CLASSIC) {
        let shape: CAShapeLayer = CAShapeLayer()
        shape.strokeColor = color.cgColor
        shape.lineWidth = thickness
        shape.lineDashPattern = pattern
        shape.fillColor = UIColor.clear.cgColor
        
        let path = UIBezierPath()
        for edge in edges {
            switch edge {
            case .top:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
            case .bottom:
                path.move(to: CGPoint(x: 0, y: self.bounds.height))
                path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
            case .left:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
            case .right:
                path.move(to: CGPoint(x: self.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
            default:
                return
            }
        }
        
        shape.path = path.cgPath
        self.layer.addSublayer(shape)
    }
    
    internal func addBorder(edges: [UIRectEdge], color: UIColor = .separator, thickness: CGFloat = 1) {
        let line: CALayer = CALayer()
        line.backgroundColor = color.cgColor
        
        for edge in edges {
            switch edge {
            case .top:
                line.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
            case .bottom:
                line.frame = CGRect(x: 0, y: self.bounds.height - thickness, width: self.bounds.width, height: thickness)
            case .left:
                line.frame = CGRect(x: 0, y: 0, width: thickness, height: self.bounds.height)
            case .right:
                line.frame = CGRect(x: self.bounds.width - thickness, y: 0, width: thickness, height: self.bounds.height)
            default:
                return
            }
        }
        
        self.layer.addSublayer(line)
    }
}

extension Double {
    internal func roundedToNearest(_ threshold: Double, rule: FloatingPointRoundingRule) -> Double {
        let floorValue = self.rounded(rule)
        var distance = (floorValue + 1.0) - self
        
        switch rule {
        case .down:
            if distance <= threshold || self - floorValue >= 0.25 {
                return floorValue + 1.0
            }
        case .up:
            distance = floorValue - self
            
            return self + abs(distance - threshold)
        default:
            return floorValue
        }
        
        return floorValue
    }
}
