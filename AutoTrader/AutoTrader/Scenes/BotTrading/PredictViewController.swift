//
//  BotViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 25/04/2024.
//

import UIKit
import ProgressHUD

final class PredictViewController: UIViewController {
    
    @IBOutlet weak var realChartView: UIView!
    @IBOutlet weak var predictChartView: UIView!
    @IBOutlet weak var viewAnomaly: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var algorithmButton: UIButton!
    
    // real chart
    @IBOutlet weak var endPrice: UILabel!
    @IBOutlet weak var middlePrice: UILabel!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var middleDay: UILabel!
    @IBOutlet weak var startDay: UILabel!
    
    // predict chart
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var middle: UILabel!
    @IBOutlet weak var sPrice: UILabel!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var ePrice: UILabel!
    
    var stockDatas: [StockData]?
    var sympol: String?
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    private var stockDatasNew: [StockData] = []
    private var lineChart: SimpleLineChart!
    private let progressAnimate = ProgressAnimate()
    
    private var forecastDataArray: [Forecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configRealChart()
        setupLabelRealChart()
        setupNavigationBarTitle()
        setupButton()
        fetchForecastData(nameML: "LSTM")
    }
    
    private func setupNavigationBarTitle() {
        if let sympol = sympol {
            self.title = "\(sympol)"
        }
    }
}

extension PredictViewController {
    private func configRealChart() {
        guard let stockDatas = stockDatas else { return }
        stockDatasNew = stockDatas
        ConfigureChart.configureChart (
            in: realChartView,
            with: stockDatas,
            lineColor: .blueStock,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
    
    private func configPredictChart(forecastData: [Forecast]) {
        ConfigureChart.configureChartAnomaly (
            in: predictChartView,
            with: forecastData,
            lineColor: .greenStock,
            sizePoint: 8.0,
            lineShadowGradientStart: .greenBG,
            lineShadowGradientEnd: .greyCustom
        )
    }
}

extension PredictViewController {
    func fetchForecastData(nameML: String) {
        progressAnimate.simulateProgress {}
        guard let sympol = sympol else {
            return
        }
        
        let urlString = "https://rl.ftisu.vn/\(nameML)Predict?Symbol=\(sympol)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    print("Error fetching data: \(error)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                }
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                let preprocessedJSONString = preprocessJSON(jsonString)
                
                if let preprocessedData = preprocessedJSONString.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let forecastDataArray = try decoder.decode([Forecast].self, from: preprocessedData)
                        self.forecastDataArray = forecastDataArray
                        DispatchQueue.main.async {
                            self.configPredictChart(forecastData: forecastDataArray)
                            self.setupLabelPredictChart(forecastData: forecastDataArray)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showAlert(title: "ERROR", message: "No data response")
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

extension PredictViewController {
    @IBAction func detailButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    @IBAction func botButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let botViewController = storyboard.instantiateViewController(withIdentifier: "BotViewController") as? BotViewController {
            botViewController.delegate = self
            if let sheet = botViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            present(botViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.foreCast = forecastDataArray
            }
        } else if segue.identifier == "toBotView" {
            // Pass data to BotViewController if needed
        } else if segue.identifier == "pushAgentView" {
            
        }
    }
}

extension PredictViewController {
    private func setupUI() {
        viewAnomaly.layer.cornerRadius = viewAnomaly.frame.size.width / 2
        viewAnomaly.clipsToBounds = true
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.white.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        viewInfo.layer.addSublayer(topBorder)
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.white.cgColor
        bottomBorder.frame = CGRect(x: 0, y: viewInfo.frame.height - 1, width: view.frame.width, height: 1)
        viewInfo.layer.addSublayer(bottomBorder)
    }
    
    private func setupLabelRealChart() {
        guard !stockDatasNew.isEmpty else {
            return
        }
        
        let firstStockData = stockDatasNew.first
        let middleIndex = stockDatasNew.count / 2
        let middleStockData = stockDatasNew[middleIndex]
        let lastStockData = stockDatasNew.last
        
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
    
    private func setupLabelPredictChart(forecastData: [Forecast]) {
        guard !forecastData.isEmpty else {
            return
        }
        
        let firstStockData = forecastData.first
        let middleIndex = forecastData.count / 2
        let middleStockData = forecastData[middleIndex]
        let lastStockData = forecastData.last
        
        let startPriceText = firstStockData?.forecast?.formattedWithSeparator() ?? ""
        let middlePriceText = middleStockData.forecast?.formattedWithSeparator()
        let endPriceText = lastStockData?.forecast?.formattedWithSeparator() ?? ""
        
        self.ePrice.text = startPriceText
        self.mPrice.text = middlePriceText
        self.sPrice.text = endPriceText
        
        guard let firstDay = firstStockData?.date else { return }
        guard let lastDay = lastStockData?.date else { return }
        
        let startDayText = DateHelper.convertDate(dateString: firstDay)
        let middleDayText = DateHelper.convertDate(dateString: middleStockData.date ?? "")
        let endDayText = DateHelper.convertDate(dateString: lastDay)
        
        self.start.text = startDayText
        self.middle.text = middleDayText
        self.end.text = endDayText
    }
}

extension PredictViewController {
    private func setupButton() {
        algorithmButton.menu = createMenu()
        algorithmButton.showsMenuAsPrimaryAction = true
    }
    
    private func createMenu() -> UIMenu {
        let lstm = UIAction(title: "LSTM") { [weak self] _ in
            DispatchQueue.main.async {
                self?.algorithmButton.setTitle("LSTM", for: .normal)
                self?.fetchForecastData(nameML: "LSTM")
            }
        }
        
        let gan = UIAction(title: "GAN") { [weak self] _ in
            DispatchQueue.main.async {
                self?.algorithmButton.setTitle("GAN", for: .normal)
                self?.fetchForecastData(nameML: "GAN")
            }
        }
        
        let menu = UIMenu(children: [lstm, gan])
        
        return menu
    }
}

extension PredictViewController: BotViewControllerDelegate {
    func botViewControllerDidDismiss(currentDay: String, futureDay: String, amount: String) {
        performSegue(withIdentifier: "pushAgentView", sender: self)
    }
}
