//
//  ChartBackground.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 06/06/26.
//

import UIKit

internal class ChartCanvasView: UIView {
    private var yAxisPoints: [CGPoint] = []
    private var chartLegends: (weights: [Double], days: [String]) = (weights: [] as [Double], days: [] as [String])
    private var axisCount: (x: Int, y: Int) = (x: 1, y: 1)
    private var axisRange: (x: Int, y: Int) = (x: 0, y: 0)
    
    internal var legendDataSources: (weights: [Double], days: [String]) = (weights: [] as [Double], days: [] as [String]) {
        didSet {
            chartLegends = legendDataSources
            axisCount.x = chartLegends.days.count
            axisCount.y = chartLegends.weights.count

            setupLayout()
        }
    }
    
    internal var dimensions: (width: CGFloat, height: CGFloat, xRange: Int, yRange: Int) = (width: 0, height: 0, xRange: 0, yRange: 0) {
        didSet {
            frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
            
            axisRange.x = dimensions.xRange
            axisRange.y = dimensions.yRange
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeRectangle(x: Int = 0, y: Int = 0,
                               xIndex: Int, yIndex: Int,
                               xRange: Int = 0
    ) -> CGRect {
        var rect: CGRect = CGRect(x: x, y: y, width: xRange, height: self.axisRange.y)
        if yIndex == axisCount.y && xIndex == axisCount.x {
            rect = CGRect(x: x, y: y - Int(rect.height), width: xRange / Int(1.8), height: self.axisRange.y)
        } else if yIndex == axisCount.y - 1 && xIndex < axisCount.x {
            var responsiveLegend = self.axisRange.y / 3
            if dimensions.yRange > (dimensions.xRange * 2) {
                responsiveLegend = self.axisRange.y / 4
            }
            
            rect = CGRect(x: x, y: y, width: xRange, height: responsiveLegend)
        } else if yIndex < axisCount.y && xIndex == axisCount.x {
            rect = CGRect(x: x, y: y - Int(rect.height), width: xRange / Int(1.8), height: self.axisRange.y)
        }
        
        return rect
    }
    
    private func makeLegendX(container: UIView, text: String) {
        let lbl: UILabel = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 8, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(lbl)
        
        NSLayoutConstraint.activate([
            lbl.topAnchor.constraint(equalTo: container.topAnchor),
            lbl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            lbl.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func makeLegendY(container: UIView, text: String) {
        let lblWeight: UILabel = UILabel()
        lblWeight.text = text
        lblWeight.font = .systemFont(ofSize: 8, weight: .bold)
        lblWeight.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(lblWeight)
        
        NSLayoutConstraint.activate([
            lblWeight.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            lblWeight.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 5)
        ])
    }
    
    private func setupLayout() {
        guard chartLegends.days.count > 0  || chartLegends.weights.count > 0 else { return }
        
        let xAxisOffsetLimit = (min: 0, max: axisCount.x) // 0...6 = offset date data, 7 = weight legend
        let yAxisOffsetLimit = (min: 0, max: axisCount.y - 1) // 0...axisCount y - 2 = offset weight data, yAxisCount - 1 = date legend
        
        var x: Int = 0
        var y: Int = 0

        for i in yAxisOffsetLimit.min...yAxisOffsetLimit.max {
            for j in xAxisOffsetLimit.min...xAxisOffsetLimit.max {
                let rect: CGRect = self.makeRectangle(x: x, y: y, xIndex: j, yIndex: i, xRange: axisRange.x)
                let rectView = UIView(frame: rect)
                
                if i == yAxisOffsetLimit.max && j < xAxisOffsetLimit.max {
                    makeLegendX(container: rectView, text: chartLegends.days[j])
                }
                
                x += axisRange.x
                
                if j != xAxisOffsetLimit.max {
                    if i == yAxisOffsetLimit.min {
                        rectView.addBorder(edges: [.top], color: .lightGray, thickness: 1.125)
                        rectView.addDashBorder(edges: [.bottom], color: .lightGray)
                    } else if i > yAxisOffsetLimit.min && i < yAxisOffsetLimit.max - 1 {
                        rectView.addDashBorder(edges: [.bottom], color: .lightGray)
                    } else if i == yAxisOffsetLimit.max - 1 {
                        rectView.addBorder(edges: [.bottom], color: .lightGray, thickness: 1.125)
                    }
                }
                
                if j == xAxisOffsetLimit.min && j != xAxisOffsetLimit.max {
                    rectView.addDashBorder(edges: [.left], color: .lightGray)
                    rectView.addDashBorder(edges: [.right], color: .lightGray)
                } else if j > xAxisOffsetLimit.min && j < xAxisOffsetLimit.max - 1 {
                    rectView.addDashBorder(edges: [.right], color: .lightGray)
                } else if j == xAxisOffsetLimit.max - 1 {
                    rectView.addDashBorder(edges: [.right], color: .lightGray)
                } else {
                    self.makeLegendY(container: rectView, text: String(format: "%.2f", chartLegends.weights[i]))
                    
                    y += Int(rect.height)
                    let point = CGPoint(x: x, y: y)
                    yAxisPoints.append(point)
                    
                    x = 0
                }
                
                self.addSubview(rectView)
            }
        }
    }
}
