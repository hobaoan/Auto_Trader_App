//
//  ChartViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit

final class ChartViewController: UIViewController {
    
    @IBOutlet weak var av1View: UIView!
    @IBOutlet weak var av2View: UIView!
    @IBOutlet weak var av3View: UIView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var startDay: UILabel!
    @IBOutlet weak var middleDay: UILabel!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var middlePrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    
    @IBOutlet weak var NAV: UILabel!
    @IBOutlet weak var yearToDate: UILabel!
    @IBOutlet weak var aMonth: UILabel!
    @IBOutlet weak var aYear: UILabel!
    @IBOutlet weak var fiveYears: UILabel!
    
    
    var symbol: String?
    var userID: Int?
    private var stockDatas: [StockData] = []
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    private let today = DateHelper.getCurrentDate()
    private let oneMonthAgo = DateHelper.getDateMonthAgo()
    private let oneYearAgo = DateHelper.getDateYearAgo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllStockData()
        setupNavigationBarTitle()
        buttonTapped(allButton)
    }
    
    private func configChart(stockDatas: [StockData]) {
        chartView.subviews.forEach { $0.removeFromSuperview() }
        ConfigureChart.configureChart(
            in: chartView,
            with: stockDatas,
            lineColor: .blueStock,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
}

// MARK: - Handle data

extension ChartViewController {
    private func setupNavigationBarTitle() {
        if let symbol = symbol {
            self.title = symbol
        }
    }
    
    private func fetchAllStockData() {
        guard let symbol = symbol else {
            return
        }
        stockRepository.getStockWithSympol(sympol: symbol) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stock):
                self.stockDatas = stock.stockDatas
                fetchStockInfo(id: stock.id)
                DispatchQueue.main.async {
                    self.configChart(stockDatas: self.stockDatas)
                    self.setupLabelChart()
                }
            case .failure(_):
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
    }
    
    private func fetchMonthStockData() {
        guard let symbol = symbol else {
            return
        }
        stockRepository.getStockWithTime(sympol: symbol, startDay: oneMonthAgo, endDay: today) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stock):
                self.stockDatas = stock.stockDatas
                DispatchQueue.main.async {
                    self.configChart(stockDatas: self.stockDatas)
                    self.setupLabelChart()
                }
            case .failure(_):
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
    }
    
    private func fetchYearStockData() {
        guard let symbol = symbol else {
            return
        }
        stockRepository.getStockWithTime(sympol: symbol, startDay: oneYearAgo, endDay: today) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stock):
                self.stockDatas = stock.stockDatas
                DispatchQueue.main.async {
                    self.configChart(stockDatas: self.stockDatas)
                    self.setupLabelChart()
                }
            case .failure(_):
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
    }
    
    private func fetchStockInfo(id: Int) {
        stockRepository.getStockInfo (id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stockInfo):
                DispatchQueue.main.async {
                    self.setUpUI(stockInfo: stockInfo)
                }
            case .failure(_):
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
    }

    
    private func setupLabelChart() {
        guard !stockDatas.isEmpty else {
            return
        }
        
        let firstStockData = stockDatas.first
        let middleIndex = stockDatas.count / 2
        let middleStockData = stockDatas[middleIndex]
        let lastStockData = stockDatas.last
        
        let startPriceText = firstStockData?.close.formattedWithSeparator() ?? ""
        let middlePriceText = middleStockData.close.formattedWithSeparator()
        let endPriceText = lastStockData?.close.formattedWithSeparator() ?? ""
        
        self.startPrice.text = startPriceText
        self.middlePrice.text = middlePriceText
        self.endPrice.text = endPriceText
        
        guard let firstDay = firstStockData?.date else { return }
        guard let lastDay = lastStockData?.date else { return }
        
        let startDayText = DateHelper.convertDateOrther(dateString: firstDay)
        let middleDayText = DateHelper.convertDateOrther(dateString: middleStockData.date)
        let endDayText = DateHelper.convertDateOrther(dateString: lastDay)
        
        self.startDay.text = startDayText
        self.middleDay.text = middleDayText
        self.endDay.text = endDayText
    }
}

// MARK: - Action button tapped

extension ChartViewController {
    @IBAction func predictionButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toPredictionView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPredictionView" {
            if let predictViewController = segue.destination as? PredictViewController {
                predictViewController.stockDatas = self.stockDatas
                predictViewController.sympol = self.symbol
                predictViewController.userId = self.userID
            }
        }
    }
}

// MARK: - Button filter stock data

extension ChartViewController {
    @objc private func buttonTapped(_ sender: UIButton) {
        allButton.backgroundColor = .opaqueSeparator
        yearButton.backgroundColor = .opaqueSeparator
        dayButton.backgroundColor = .opaqueSeparator
        sender.backgroundColor = .systemOrange
        handleButtonTap(for: sender)
    }
    
    private func handleButtonTap(for button: UIButton) {
        switch button {
        case allButton:
            fetchAllStockData()
        case yearButton:
            fetchYearStockData()
        case dayButton:
            fetchMonthStockData()
        default:
            break
        }
    }
}

// MARK: - setupUI

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
    
    private func setUpUI(stockInfo: StockInfo) {
        guard let navValue = stockInfo.lastDayPrice.formattedWithSeparator() else { return }
        NAV.text = "\(navValue) VND"
        yearToDate.text = "\(Int(stockInfo.profitPercentYearToDate)) %"
        aMonth.text = "\(Int(stockInfo.profitPercent30Days)) %"
        aYear.text = "\(Int(stockInfo.profitPercentLastYear)) %"
        fiveYears.text = "\(Int(stockInfo.profitPercent5YearsAgo)) %"
    }
}
