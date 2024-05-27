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
    
    private let stockData = generateStockDataFromCSV()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configChart()
        buttonTapped(allButton)
    }
    
    private func configChart() {
        ChartConfigurator.configureChart(
            in: chartView,
            with: stockData,
            lineColor: .blueStock,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
}

// MARK: - Action button tapped

extension ChartViewController {
    @IBAction func predictionButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toPredictionView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPredictionView" {
        }
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
