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
    private let chartCanvasView: ChartCanvasView = ChartCanvasView()
    private let summaryView: ChartSummaryView = ChartSummaryView()
    private lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [titleView, legendsView])
    
    private var axisXCount: Int = 7 // based on days count (should be mutable in the future)
    private var axisYCount: Int = 1
    private var chartLegends: (weights: [Double], days: [String]) = (weights: [] as [Double], days: [] as [String])
    private var points: [CGPoint] = []
    
    internal var collection: [Weights] = [] {
        didSet {
            if !collection.isEmpty {
                axisYCount = collection.count

                setNeedsDisplay()
            }
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
        
        calculateLegends()
        setSubviewComponents()
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard collection.count > 0, chartLegends.weights.count > 0 else { return }
        
        drawLines()
        setDataPoints()
    }
    
    private func setSubviewComponents() {
        legendsView.items = [
            Legends(text: "Weight", size: 10, color: UIColor.systemRed, shape: "circle"),
            Legends(text: "Steps", size: 10, color: UIColor.systemBlue, shape: "square")
        ]
        
        chartCanvasView.legendDataSources = chartLegends
    }
    
    private func setDataPoints() {
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
        }
    }
    
    private func setupSubViews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        chartCanvasView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chartCanvasView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            chartCanvasView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding * 1.25),
            chartCanvasView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            chartCanvasView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
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
        
        minWeight = minWeight.roundedToNearest(0.5, rule: .down)
        maxWeight = maxWeight.roundedToNearest(0.5, rule: .up)
        
        for point in stride(from: maxWeight, to: minWeight, by: -0.5) { // formerly decremented by yRange
            chartLegends.weights.append(point)
        }

        chartLegends.weights.append(minWeight) // for legend's 0 point
        print("legends =", chartLegends.weights)
        if let startDate = sortedCollection.first {
            chartLegends.days.append(contentsOf: Helpers.getDaysOfWholeWeek(startDate: startDate.date))
        }
    }
    
    private func getAxisLocation(_ legends: [Double], _ value: Double) -> (index: Int, remainder: Double) {
        var smallestRemainder: (index: Int, remainder: Double) = (index: 0, remainder: 0)
        for (index, num) in legends.enumerated() {
            if num > value { continue }
            
            if num - value <= 0 && value > smallestRemainder.remainder {
                smallestRemainder = (index: legends.count - (index + 1), remainder: abs(num - value))
                // index = decrement version of legends index
                // it is 4, 3, 2, 1, 0 of 0, 1, 2, 3, 4
                
                break // return after the first element found (because it is sorted, iterating the whole element would be redundant)
            }
        }
        
        return smallestRemainder
    }
    
    private func drawLines() {
        let path = UIBezierPath();
        let bgWidth: CGFloat = chartCanvasView.bounds.width - 25 // - 25 untuk tempat y axis legends
        let bgHeight: CGFloat = CGFloat((chartLegends.weights.count - 1) * 50)
        let axisHeight: Int = Int(bgHeight) / axisYCount
        let xRange: CGFloat = CGFloat(Int(bgWidth) / axisXCount) // width / days
        let drawableY: CGFloat = self.bounds.origin.y + self.layoutMargins.top + stackView.bounds.height + (self.layoutMargins.top * 1.25)
        let drawableX: CGFloat = self.bounds.origin.x + self.layoutMargins.left
        
        var point: CGPoint = CGPoint(x: drawableX, y: drawableY) // starting point

        points.append(point)
        path.move(to: point)
     
        let sortedCollection = WeightStore.shared.collection.sorted(by: { $0.date < $1.date }).map(\.weight); print("collection = ", sortedCollection)
        let yLeadingPoint = point.y // 111.0
        let yTrailingPoint = point.y + CGFloat(bgHeight) // 311.0
        let yPointRangeByAxis = (yTrailingPoint - yLeadingPoint) / Double(axisYCount - 1) // - 1 soalnya sebenernya bottom rangenya di axis #x - 1
        
        /***
            Legend -> axis convertion calculation
            
            Example
                x = 50
                4 48   = 311 - (x * 0)
                3 48.5 = 311 - x
                2 49   = 311 - x - x
                1 49.5 = 311 - x - x - x
                0 50   = 311 - x - x - x - x
             
                [50, 49.5, 49.0, 48.5, 48]
                [4, 3, 2, 1, 0]
         */
        for (index, data) in sortedCollection.enumerated() {
            if index == 0 {
                point.x += (xRange / 2)
            } else {
                point.x += xRange
            }
            
            let axisLocation = getAxisLocation(chartLegends.weights, data)
            point.y = yTrailingPoint - CGFloat(axisHeight * axisLocation.index) - (yPointRangeByAxis / CGFloat(axisHeight) * axisLocation.remainder * 100)
            path.addLine(to: point)
            
            points.append(point)
            path.move(to: point)
            
            if index == sortedCollection.count - 1 {
                point.x += (xRange / 2)
                
                path.addLine(to: point)
            }
        }
        
        UIColor.systemRed.setStroke()
        path.lineWidth = 2
        path.stroke()
    }
}
