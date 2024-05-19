//
//  SymbolTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit
import Reusable
import SimpleLineChart

final class SymbolTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var sympolLabel: UILabel!
    @IBOutlet weak var miniChartView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    let stockData = generateStockDataFromCSV()
    var lineChart: SimpleLineChart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(sympol: String, price: String, textColor: UIColor) {
        sympolLabel.text = sympol
        priceLabel.text = price
        priceLabel.textColor = textColor
        setupChart()
    }
    
    func setupChart() {
        let values = stockData.enumerated().map { index, data in
            return SLCData(x: index, y: data.close)
        }
        
        lineChart = SimpleLineChart(frame: miniChartView.bounds)
        
        let dataSet = SLCDataSet(graphPoints: values)
        lineChart.loadPoints(dataSet: dataSet)
        
        let chartStyle = SLCChartStyle(backgroundGradient: false,
                                       solidBackgroundColor: .greyCustom)
        lineChart.setChartStyle(chartStyle: chartStyle)
        
        let lineStyle = SLCLineStyle(lineColor: .greenStock,
                                     lineStroke: 1.0,
                                     lineShadow: false)
        dataSet.setLineStyle(lineStyle)
        miniChartView.addSubview(lineChart)
    }
}
