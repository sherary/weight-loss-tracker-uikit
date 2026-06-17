//
//  WeightChartView.swift
//  weight-loss-tracker
//
//  Created by Sherary Apriliana on 29/05/26.
//

import UIKit

final class WeightChartView: UIView {
    private let padding: CGFloat = 20
    private let titleView: ChartTitleView = ChartTitleView()
    private let legendsView: ChartLegendsView = ChartLegendsView()
    private lazy var chartCanvasView: ChartCanvasView = ChartCanvasView()
    private lazy var summaryView: ChartSummaryView = ChartSummaryView()
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [titleView, legendsView])
    
    private let commonDenominator: Double = 0.5
    private var axisXCount: Int = 7 // based on days count (should be mutable in the future)
    private var axisYCount: Int = 1
    private var chartLegends: (weights: [Double], days: [String]) = (weights: [] as [Double], days: [] as [String])
    private var dimensions: (width: CGFloat, height: CGFloat, xRange: Int, yRange: Int) = (width: 0, height: 0, xRange: 0, yRange: 0)
    private var points: [CGPoint] = []
    private var dotViews: [UIView] = []
    
    internal var collection: [Weights] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    internal var title: String = "Chart Title" {
        didSet {
            titleView.title = title
        }
    }
    
    internal var subTitle: String = "Chart Subtitle" {
        didSet {
            titleView.subTitle = subTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        guard WeightStore.shared.collection.count > 0 else { return }
            
        calculateLegends()
        setDrawableDimensions()
        setSubviewComponents()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard WeightStore.shared.collection.count > 0, chartLegends.weights.count > 0 else { return }
        points.removeAll()
        
        drawLines()
        setDataPoints()
    }
    
    private func setSubviewComponents() {
        legendsView.items = [
            Legends(text: "Weight", size: 10, color: UIColor.systemRed, shape: "circle"),
            Legends(text: "Steps", size: 10, color: UIColor.systemBlue, shape: "square")
        ]
        
        chartCanvasView.dimensions = dimensions
        chartCanvasView.legendDataSources = chartLegends
        
        let collection = WeightStore.shared.collection
        
        if collection.count < axisXCount { return }
        summaryView.weights = collection.sorted(by: { $0.date < $1.date }).map(\.weight)
    }
    
    private func setDataPoints() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        let dotSize: CGFloat = 8
        for (index, point) in points.enumerated() {
            if index == 0 { continue }
            
            let dot = UIView()
            dot.backgroundColor = .systemBackground
            dot.layer.borderColor = UIColor.systemRed.cgColor
            dot.layer.borderWidth = 2
            dot.layer.cornerRadius = dotSize / 2
            dot.frame = CGRect(
                x: point.x - dotSize / 2,
                y: point.y - dotSize / 2,
                width: dotSize,
                height: dotSize
            )
            
            self.addSubview(dot)
            dotViews.append(dot)
        }
    }
    
    private func setupSubViews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        chartCanvasView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartCanvasView)
        
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(summaryView)
        
        let actualHeight = dimensions.height - (CGFloat(dimensions.yRange) * Multiply.byHalf)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            chartCanvasView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding * Multiply.byOneQuarter),
            chartCanvasView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            chartCanvasView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            chartCanvasView.heightAnchor.constraint(equalToConstant: actualHeight),
            
            summaryView.topAnchor.constraint(equalTo: chartCanvasView.bottomAnchor, constant: padding * Multiply.byHalf),
            summaryView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            summaryView.heightAnchor.constraint(equalTo: layoutMarginsGuide.heightAnchor, constant: padding * -1)
        ])
    }
    
    private func calculateLegends() {
        var minWeight: Double = 0
        var maxWeight: Double = 0
        let sortedCollection = WeightStore.shared.collection.sorted(by: { $0.date < $1.date }).map { (weight: $0.weight, date: $0.date) }
        
        for data in sortedCollection {
            if data.weight < minWeight || minWeight == 0 {
                minWeight = data.weight
            }
            
            if minWeight > maxWeight {
                let temp: Double = maxWeight
                maxWeight = minWeight
                minWeight = temp
            }
        }
        
        if minWeight == 0 {
            minWeight = maxWeight.roundedToNearest(commonDenominator, rule: .down)
            maxWeight = minWeight + 1
        } else {
            minWeight = minWeight.roundedToNearest(commonDenominator, rule: .down)
            maxWeight = maxWeight.roundedToNearest(commonDenominator, rule: .up)
        }
        
        let decrementDenominator = commonDenominator * -1
        for point in stride(from: maxWeight, to: minWeight, by: decrementDenominator) {
            chartLegends.weights.append(point)
        }

        chartLegends.weights.append(minWeight) // for y range's 0 point
        
        if let startDate = sortedCollection.first {
            chartLegends.days.append(contentsOf: Helpers.getDaysOfWholeWeek(startDate: startDate.date))
        }
        
        axisYCount = chartLegends.weights.count
    }
    
    private func setDrawableDimensions() {
        dimensions.xRange = 42
        dimensions.width = CGFloat(dimensions.xRange * axisXCount)
        dimensions.yRange = Int(Double(dimensions.xRange) * Multiply.byOneHalf)
        dimensions.height = CGFloat(dimensions.yRange * axisYCount)
    }
    
    private func getAxisLocation(_ legends: [Double], _ value: Double) -> (index: Int, remainder: Double) {
        var smallestRemainder: (index: Int, remainder: Double) = (index: 0, remainder: 0)

        for (index, num) in legends.enumerated() {
            if num > value { continue }
            
            if num - value <= 0 && value > smallestRemainder.remainder {
                smallestRemainder = (index: legends.count - (index + 1), remainder: num - value)
                // index = decrement version of legends index
                // it is 4, 3, 2, 1, 0 of 0, 1, 2, 3, 4
                
                break // return after the first element found (because it is sorted, iterating the whole element would be redundant)
            }
        }
        
        return smallestRemainder
    }
    
    /***
        Important!
            Top (upper left)
                x: chartCanvasView.frame.origin.x
                y: chartCanvasView.frame.origin.y
            Down (down right)
                let drawableX = CGFloat(dimensions.xRange * axisXCount)
                let drawableY = CGFloat(dimensions.yRange * (axisYCount - 1))
                
                x: chartCanvas.frame.origin.x + drawableX
                y: chartCanvas.frame.origin.y + drawableY
            
            Counting axis index start from the bottom
        Why?
     
        Because:
            Legend -> axis convertion calculation
             
            Example
                x = 50
          
                3 57.5   = 311 - (x * 0)
                2 57.0   = 311 - x or 311 - (x * 1)
                1 56.5   = 311 - x - x or 311 - (x * 2)
                0 56.0   = 311 - x - x - x or 311 - (x * 3)
                 
            In short -> bounds.width - (x * n)
                n = legends[i]
          
                [57.5, 57.0, 56.5, 56.0]
                [3,    2,    1,    0]
        Note:
            Starting point  =    (16.0, 104.3)
            Ending point    =    (310.0, 293.3)
     */
    
    private func drawLines() {
        guard collection.count > 0 else { return }
        
        let path = UIBezierPath()
        let drawableY: CGFloat = CGFloat(dimensions.yRange * (axisYCount - 1))
        
        var point: CGPoint = CGPoint(x: chartCanvasView.frame.origin.x, y: chartCanvasView.frame.origin.y)
        let sortedWeight = WeightStore.shared.collection.sorted(by: { $0.date < $1.date }).map(\.weight)
        
        for (index, item) in sortedWeight.enumerated() {
            if index == 0 {
                path.move(to: point)
                points.append(point)
                
                point.x += CGFloat(dimensions.xRange / 2)
            } else {
                point.x += CGFloat(dimensions.xRange)
            }
            
            let axis = getAxisLocation(chartLegends.weights, item)
            let bottomY = chartCanvasView.frame.origin.y + drawableY
            let axisLocation = CGFloat(axis.index * dimensions.yRange)
            let roundedRange = round(axis.remainder * 10) / 10
            let dimensionByFraction = CGFloat(dimensions.yRange) / commonDenominator
            
            point.y = bottomY - axisLocation + (dimensionByFraction * roundedRange)
            
            path.addLine(to: point)
            path.move(to: point)
            points.append(point)
            
            if index == sortedWeight.count - 1 && sortedWeight.count == axisXCount {
                point.x += CGFloat(dimensions.xRange / 2)
            
                path.addLine(to: point)
            }
        }
        
        UIColor.systemRed.setStroke()
        path.lineWidth = 2
        path.stroke()
    }
}
