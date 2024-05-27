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
    
    private let stockData = generateStockDataFromCSV()
    private let stockPredictData = dataPredicted()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configRealChart()
        configPredictChart()
    }
}

extension PredictViewController {
    private func configRealChart() {
        ChartConfigurator.configureChart(
            in: realChartView,
            with: stockData,
            lineColor: .blueStock,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
    
    private func configPredictChart() {
        ChartConfigurator.configureChart(
            in: predictChartView,
            with: stockPredictData,
            lineColor: .greenStock,
            lineShadowGradientStart: .greenShadow,
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
