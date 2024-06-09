//
//  DetailViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 19/05/2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startDay: UILabel!
    @IBOutlet weak var middleDay: UILabel!
    @IBOutlet weak var endDay: UILabel!
    
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var middlePrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    
    private let stockPredictData = dataPredictedAnomaly()
    private var lineChart: SimpleLineChart!
    private var foreCastArray: [Forecast] = []
    var foreCast: [Forecast]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configChart()
        setupLabelChart()
        configTableView()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(cellType: PredictTableViewCell.self)
    }
    
    private func configChart() {
        guard let foreCast = foreCast else { return }
        foreCastArray = foreCast
        ConfigureChart.configureChartAnomaly (
            in: chartView,
            with: foreCast,
            lineColor: .blueStock,
            sizePoint: 8.0,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
    
    private func setupLabelChart() {
        guard !foreCastArray.isEmpty else {
            return
        }
        
        let firstStockData = foreCastArray.first
        let middleIndex = foreCastArray.count / 2
        let middleStockData = foreCastArray[middleIndex]
        let lastStockData = foreCastArray.last
        
        let startPriceText = firstStockData?.forecast?.formattedWithSeparator() ?? ""
        let middlePriceText = middleStockData.forecast?.formattedWithSeparator()
        let endPriceText = lastStockData?.forecast?.formattedWithSeparator() ?? ""
        
        self.endPrice.text = startPriceText
        self.middlePrice.text = middlePriceText
        self.startPrice.text = endPriceText
        
        guard let firstDay = firstStockData?.date else { return }
        guard let lastDay = lastStockData?.date else { return }
        
        let startDayText = DateHelper.convertDate(dateString: firstDay)
        let middleDayText = DateHelper.convertDate(dateString: middleStockData.date ?? "")
        let endDayText = DateHelper.convertDate(dateString: lastDay)
        
        self.startDay.text = startDayText
        self.middleDay.text = middleDayText
        self.endDay.text = endDayText
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCast?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictTableViewCell", for: indexPath) as! PredictTableViewCell
        let dataForecast = foreCast?[indexPath.row]
        let anomalyImage: UIImage? = UIImage(named: "anomalyIcon")
        if dataForecast?.anomaly == -1 {
            cell.setContent(date: dataForecast?.date ?? "",
                            price: dataForecast?.forecast?.formattedWithSeparator() ?? "",
                            anomalyImage: anomalyImage)
        }
        else {
            cell.setContent(date: dataForecast?.date ?? "",
                            price: dataForecast?.forecast?.formattedWithSeparator() ?? "",
                            anomalyImage: UIImage(named: ""))
        }
        return cell
    }
}
