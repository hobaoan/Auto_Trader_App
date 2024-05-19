//
//  ChartViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit
import SimpleLineChart

final class ChartViewController: UIViewController {
    
    @IBOutlet weak var av1View: UIView!
    @IBOutlet weak var av2View: UIView!
    @IBOutlet weak var av3View: UIView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    
    let stockData = generateStockDataFromCSV()
    var lineChart: SimpleLineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configChart()
        buttonTapped(allButton)
    }
    
}

// MARK: - configure line chart

extension ChartViewController {
    func configChart() {
        let values = stockData.enumerated().map { index, data in
            return SLCData(x: index, y: data.close)
        }
        
        lineChart = SimpleLineChart(frame: chartView.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: .blueStock,
                                     lineStroke: 3.0,
                                     lineShadow: true,
                                     lineShadowgradientStart: .blueShadow,
                                     lineShadowgradientEnd: .greyCustom)
        dataSet.setLineStyle(lineStyle)
        chartView.addSubview(lineChart)
    }
}

// MARK: - setupUI

extension ChartViewController {
    @objc private func buttonTapped(_ sender: UIButton) {
        allButton.backgroundColor = .opaqueSeparator
        yearButton.backgroundColor = .opaqueSeparator
        dayButton.backgroundColor = .opaqueSeparator
        sender.backgroundColor = .systemOrange
    }
}

extension ChartViewController {
    private func setupUI() {
        configureCornerView(view: av1View)
        configureCornerView(view: av2View)
        configureCornerView(view: av3View)
        configureCornerButton(button: allButton)
        configureCornerButton(button: yearButton)
        configureCornerButton(button: dayButton)
        allButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        dayButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    private func configureCornerView(view: UIView) {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    private func configureCornerButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
    }
}
