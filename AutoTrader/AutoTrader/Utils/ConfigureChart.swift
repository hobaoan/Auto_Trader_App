//
//  configureChart.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import UIKit
import SimpleLineChart

struct ConfigureChart {
    static func configureChart(in view: UIView, with data: [StockData], lineColor: UIColor, lineShadowGradientStart: UIColor, lineShadowGradientEnd: UIColor) {
        let values = data.enumerated().map { index, data in
            return SLCData(x: index, y: data.close)
        }
        
        let lineChart = SimpleLineChart(frame: view.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: lineColor,
                                     lineStroke: 2.0,
                                     lineShadow: true,
                                     lineShadowgradientStart: lineShadowGradientStart,
                                     lineShadowgradientEnd: lineShadowGradientEnd)
        dataSet.setLineStyle(lineStyle)
        view.addSubview(lineChart)
    }
}

