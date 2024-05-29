//
//  ChartConfigurator.swift
//  AutoTrader
//
//  Created by An Bảo on 21/05/2024.
//

import UIKit

final class ChartConfigurator {

    static func configureChart(in view: UIView, with data: [StockDataTest], lineColor: UIColor, lineShadowGradientStart: UIColor, lineShadowGradientEnd: UIColor) {
        let values = data.enumerated().map { index, data in
            return SLCData(x: index, y: data.close, z: Int(data.close))
        }
        
        let lineChart = SimpleLineChart(frame: view.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: lineColor,
                                     lineStroke: 3.0,
                                     lineShadow: true,
                                     lineShadowgradientStart: lineShadowGradientStart,
                                     lineShadowgradientEnd: lineShadowGradientEnd)
        dataSet.setLineStyle(lineStyle)
        view.addSubview(lineChart)
    }
}
