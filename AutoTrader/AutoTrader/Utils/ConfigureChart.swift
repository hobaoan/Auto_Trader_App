//
//  configureChart.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import UIKit

struct ConfigureChart {
    
    // MARK: setup Chart
    static func configureChart(in view: UIView,
                               with data: [StockData],
                               lineColor: UIColor,
                               lineShadowGradientStart: UIColor,
                               lineShadowGradientEnd: UIColor) {
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
                                     lineStroke: 2.0,
                                     lineShadow: true,
                                     lineShadowgradientStart: lineShadowGradientStart,
                                     lineShadowgradientEnd: lineShadowGradientEnd)
        dataSet.setLineStyle(lineStyle)
        view.addSubview(lineChart)
    }
    
    // MARK: setup Chart Anomaly
    static func configureChartAnomaly(in view: UIView,
                               with data: [AnomalyData],
                               lineColor: UIColor,
                               sizePoint: CGFloat,
                               lineShadowGradientStart: UIColor,
                               lineShadowGradientEnd: UIColor) {
        let values = data.enumerated().map { index, data in
            return SLCData(x: index, y: data.close, z: Int(data.anomaly) ?? 0)
        }
        
        let lineChart = SimpleLineChart(frame: view.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: lineColor,
                                     lineStroke: 3.0,
                                     circleDiameter: sizePoint,
                                     lineShadow: true,
                                     lineShadowgradientStart: lineShadowGradientStart,
                                     lineShadowgradientEnd: lineShadowGradientEnd)
        dataSet.setLineStyle(lineStyle)
        view.addSubview(lineChart)
    }
    
    // MARK: setup Chart Agent
    static func configureChartAgent(in view: UIView,
                               with data: [Agent],
                               lineColor: UIColor,
                               agentSizePoint: CGFloat,
                               lineShadowGradientStart: UIColor,
                               lineShadowGradientEnd: UIColor) {
        
        let values = data.enumerated().map { index, data in
            return SLCData(x: index, y: data.close, z: Int(data.action))
        }
        
        let lineChart = SimpleLineChart(frame: view.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: lineColor,
                                     lineStroke: 3.0,
                                     agentPoint: agentSizePoint,
                                     lineShadow: true,
                                     lineShadowgradientStart: lineShadowGradientStart,
                                     lineShadowgradientEnd: lineShadowGradientEnd)
        dataSet.setLineStyle(lineStyle)
        view.addSubview(lineChart)
    }
}

