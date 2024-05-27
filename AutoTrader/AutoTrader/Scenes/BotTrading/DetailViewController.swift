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
    
    private let stockPredictData = dataPredicted()
    
    let symbols = [
        Cell(symbol: "20/05/2024", price: "27.450"),
        Cell(symbol: "21/05/2024", price: "15.300"),
        Cell(symbol: "22/05/2024", price: "10.750"),
        Cell(symbol: "23/05/2024", price: "22.100"),
        Cell(symbol: "24/05/2024", price: "30.500"),
        Cell(symbol: "25/05/2024", price: "22.800"),
        Cell(symbol: "26/05/2024", price: "19.300"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configChart()
        configTableView()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(cellType: PredictTableViewCell.self)
    }
    
    private func configChart() {
        ChartConfigurator.configureChart(
            in: chartView,
            with: stockPredictData,
            lineColor: .greenStock,
            lineShadowGradientStart: .greenShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
}

extension DetailViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictTableViewCell", for: indexPath) as! PredictTableViewCell
        let symbol = symbols[indexPath.row]
        cell.setContent(date: symbol.symbol, price: symbol.price)
        return cell
    }
}

struct Cell {
    let symbol: String
    let price: String
}
