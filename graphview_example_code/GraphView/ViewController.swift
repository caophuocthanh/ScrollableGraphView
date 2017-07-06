//
//  Simple example usage of ScrollableGraphView.swift
//  #################################################
//

import UIKit

class ViewController: UIViewController, ScrollableGraphViewDataSource {

    var graphView: ScrollableGraphView!
    var currentGraphType = GraphType.multiOne
    var graphConstraints = [NSLayoutConstraint]()
    
    var label = UILabel()
    var reloadLabel = UILabel()
    
    // Data
    var numberOfDataItems = 29
    
    lazy var data: [Double] = self.generateRandomData(self.numberOfDataItems, max: 50)
    //lazy var labels: [String] = self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
    
    // Data for new delegate based method
    lazy var blueLinePlotData: [Double] = self.generateRandomData(self.numberOfDataItems, max: 60)
    lazy var orangeLinePlotData: [Double] =  self.generateRandomData(self.numberOfDataItems, max: 40)
    
    //lazy var linePlotData: [Double] = self.generateRandomData(self.numberOfDataItems, max: 50)
    lazy var linePlotData: [Double] = [10, 20, 25, 30, 15, 35, 45, 50, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
    //lazy var barPlotData: [Double] =  self.generateRandomData(self.numberOfDataItems, max: 50)
    lazy var barPlotData: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
    lazy var dotPlotData: [Double] =  self.generateRandomData(self.numberOfDataItems, variance: 4, from: 25)
    lazy var xAxisLabels: [String] =  self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView = createMultiPlotGraphOne(self.view.frame)
        
        addReloadLabel(withText: "RELOAD")
        addLabel(withText: "MULTI 1 (TAP HERE)")
        
        self.view.insertSubview(graphView, belowSubview: reloadLabel)
        
        setupConstraints()
    }
    
    func didTap(_ gesture: UITapGestureRecognizer) {
        
        currentGraphType.next()
        
        self.view.removeConstraints(graphConstraints)
        graphView.removeFromSuperview()
        
        switch(currentGraphType) {
        case .simple:
            graphView = createSimpleGraph(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "SIMPLE")
        case .multiOne:
            graphView = createMultiPlotGraphOne(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "MULTI 1")
        case .multiTwo:
            graphView = createMultiPlotGraphTwo(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "MULTI 2")
        case .dark:
            graphView = createDarkGraph(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "DARK")
        case .dot:
            graphView = createDotGraph(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "DOT")
        case .bar:
            graphView = createBarGraph(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "BAR")
        case .pink:
            graphView = createPinkGraph(self.view.frame)
            addReloadLabel(withText: "RELOAD")
            addLabel(withText: "PINK")
        }
        
        self.view.insertSubview(graphView, belowSubview: reloadLabel)
        
        setupConstraints()
    }
    
    func reloadDidTap(_ gesture: UITapGestureRecognizer) {
        
        // TODO: Currently changing the number of data items is not supported.
        // It is only possible to change the the actual values of the data before reloading.
        // numberOfDataItems = 30

        blueLinePlotData = self.generateRandomData(self.numberOfDataItems, max: 60)
        orangeLinePlotData = self.generateRandomData(self.numberOfDataItems, max: 40)
        
        linePlotData = self.generateRandomData(self.numberOfDataItems, max: 50)
        //barPlotData =  self.generateRandomData(self.numberOfDataItems, max: 50)
        barPlotData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]
        dotPlotData = self.generateRandomData(self.numberOfDataItems, variance: 4, from: 25)
        xAxisLabels = self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
        
        graphView.reload()
    }
    
    fileprivate func createSimpleGraph(_ frame: CGRect) -> ScrollableGraphView {
        let linePlot = LinePlot(identifier: "line")
        let referenceLines = ReferenceLines()
        
        // Compose the graph view by creating a graph, then adding the plot, followed by adding the reference lines.
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        return graphView
    }
    
    // Multi plot v1
    // TODO: This is obviously not great. Need to incorporate the dot drawing layer into
    // the line plot as well.
    fileprivate func createMultiPlotGraphOne(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the first plot.
        let blueLinePlot = LinePlot(identifier: "multiBlue")

        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#16aafc")
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // dots on the line
        let blueDotPlot = DotPlot(identifier: "multiBlueDot")
        blueDotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        blueDotPlot.dataPointSize = 5
        blueDotPlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#16aafc")
        
        blueDotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#ff7d78")
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // squares on the line
        let orangeSquarePlot = DotPlot(identifier: "multiOrangeSquare")
        orangeSquarePlot.dataPointType = ScrollableGraphViewDataPointType.square
        orangeSquarePlot.dataPointSize = 5
        orangeSquarePlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#ff7d78")
        
        orangeSquarePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.relativePositions = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: blueDotPlot)
        graphView.addPlot(plot: orangeLinePlot)
        graphView.addPlot(plot: orangeSquarePlot)
        
        return graphView
    }
    
    // Multi plot v2
    fileprivate func createMultiPlotGraphTwo(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the line plot.
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineWidth = 1
        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#16aafc")
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = UIColor.colorFromHex(hexString: "#16aafc").withAlphaComponent(0.5)
        
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second line plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineWidth = 1
        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#ff7d78")
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth

        orangeLinePlot.shouldFill = true
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = UIColor.colorFromHex(hexString: "#ff7d78").withAlphaComponent(0.5)
        
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true

        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
        
        return graphView
    }

    fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the line plot.
        let linePlot = LinePlot(identifier: "line")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.colorFromHex(hexString: "#777777")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
        linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        linePlot.animationDuration = 1.5
        
        let dotPlot = DotPlot(identifier: "overlaydot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        dotPlot.animationDuration = 1.5

        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [10, 20, 25, 30]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")

        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        // graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic // moved to plot
        // graphView.animationDuration = 1.5 // moved to plot
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        
        return graphView
    }
    
    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")
        
        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.barLineColor = UIColor.colorFromHex(hexString: "#777777")
        barPlot.barColor = UIColor.colorFromHex(hexString: "#555555")
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        
        graphView.rangeMax = 50
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        return graphView
    }
    
    private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the plot
        let plot = DotPlot(identifier: "dot")
        
        plot.dataPointSize = 5
        plot.dataPointFillColor = UIColor.white
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        referenceLines.shouldShowLabels = false
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#00BFFF")
        graphView.shouldAdaptRange = false
        graphView.shouldAnimateOnAdapt = false
        graphView.shouldAnimateOnStartup = false
        
        graphView.dataPointSpacing = 25
        graphView.rangeMax = 50
        
        // Add everything
        graphView.addPlot(plot: plot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        return graphView
    }
    
    private func createPinkGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the plot
        let linePlot = LinePlot(identifier: "line")
        
        linePlot.lineColor = UIColor.clear
        linePlot.shouldFill = true
        linePlot.fillColor = UIColor.colorFromHex(hexString: "#FF0080")
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineThickness = 1
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        referenceLines.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelColor = UIColor.white
        referenceLines.dataPointLabelsSparsity = 3
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#222222")
        
        graphView.dataPointSpacing = 20
        graphView.shouldAdaptRange = true
        graphView.rangeMax = 50
        
        // Add everything
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        return graphView
    }
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    // Adding and updating the graph switching label in the top right corner of the screen.
    private func addLabel(withText text: String) {
        
        label.removeFromSuperview()
        label = createLabel(withText: text)
        label.isUserInteractionEnabled = true
        
        let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20)
        
        let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.5)
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
        label.addGestureRecognizer(tapGestureRecogniser)
        
        self.view.insertSubview(label, aboveSubview: reloadLabel)
        self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    }
    
    private func addReloadLabel(withText text: String) {
        
        reloadLabel.removeFromSuperview()
        reloadLabel = createLabel(withText: text)
        reloadLabel.isUserInteractionEnabled = true
        
        let leftConstraint = NSLayoutConstraint(item: reloadLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 20)
        
        let topConstraint = NSLayoutConstraint(item: reloadLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20)
        
        let heightConstraint = NSLayoutConstraint(item: reloadLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: reloadLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: reloadLabel.frame.width * 1.5)
        
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(reloadDidTap))
        reloadLabel.addGestureRecognizer(tapGestureRecogniser)
        
        self.view.insertSubview(reloadLabel, aboveSubview: graphView)
        self.view.addConstraints([leftConstraint, topConstraint, heightConstraint, widthConstraint])
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }
    
    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(arc4random() % 100 < 10) {
                randomNumber *= 3
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateRandomData(_ numberOfItems: Int, variance: Double, from: Double) -> [Double] {
        
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            
            let randomVariance = Double(arc4random()).truncatingRemainder(dividingBy: variance)
            var randomNumber = from
            
            if(arc4random() % 100 < 50) {
                randomNumber += randomVariance
            }
            else {
                randomNumber -= randomVariance
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    // The type of the current graph we are showing.
    enum GraphType {
        case simple
        case multiOne
        case multiTwo
        case dark
        case bar
        case dot
        case pink
        
        mutating func next() {
            switch(self) {
            case .simple:
                self = GraphType.multiOne
            case .multiOne:
                self = GraphType.multiTwo
            case .multiTwo:
                self = GraphType.dark
            case .dark:
                self = GraphType.bar
            case .bar:
                self = GraphType.dot
            case .dot:
                self = GraphType.pink
            case .pink:
                self = GraphType.simple
            }
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // Implementation for ScrollableGraphViewDataSource protocol
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        switch(plot.identifier) {
            
        case "multiBlue":
            return blueLinePlotData[pointIndex]
        case "multiBlueDot":
            return blueLinePlotData[pointIndex]
        case "multiOrange":
            return orangeLinePlotData[pointIndex]
        case "multiOrangeSquare":
            return orangeLinePlotData[pointIndex]
        case "line":
            return linePlotData[pointIndex]
        case "overlaydot":
            return linePlotData[pointIndex]
        case "bar":
            return barPlotData[pointIndex]
        case "dot":
            return dotPlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return xAxisLabels[pointIndex] // ensure that you have a label to return for the index
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }
}

