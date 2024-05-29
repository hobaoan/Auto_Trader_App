//
//  BotViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 25/04/2024.
//

import UIKit

final class PredictViewController: UIViewController {
    
    @IBOutlet weak var realChartView: UIView!
    @IBOutlet weak var predictChartView: UIView!
    @IBOutlet weak var viewAnomaly: UIView!
    @IBOutlet weak var viewInfo: UIView!
    
    var stockDatas: [StockData]?
    
    private let stockData = generateStockDataFromCSV()
    private let stockPredictData = dataPredictedAnomaly()
    private var lineChart: SimpleLineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configRealChart()
        configPredictChart()
    }
}

extension PredictViewController {
    private func configRealChart() {
        guard let stockDatas = stockDatas else { return }
        ConfigureChart.configureChart (
            in: realChartView,
            with: stockDatas,
            lineColor: .blueStock,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
    
    private func configPredictChart() {
        ConfigureChart.configureChartAnomaly (
            in: predictChartView,
            with: stockPredictData,
            lineColor: .greenStock,
            sizePoint: 8.0,
            lineShadowGradientStart: .greenBG,
            lineShadowGradientEnd: .greyCustom
        )
    }
}

extension PredictViewController {
    @IBAction func detailButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    @IBAction func botButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let botViewController = storyboard.instantiateViewController(withIdentifier: "BotViewController") as? BotViewController {
            if let sheet = botViewController.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            present(botViewController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            // Pass data to DetailViewController if needed
        } else if segue.identifier == "toBotView" {
            // Pass data to BotViewController if needed
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
}
