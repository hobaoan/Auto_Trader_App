//
//  ViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 25/04/2024.
//

import UIKit
import Reusable

final class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let symbols = [
        Symbol(symbol: "STB", price: "27.450"),
        Symbol(symbol: "VCB", price: "15.300"),
        Symbol(symbol: "FPT", price: "10.750"),
        Symbol(symbol: "BID", price: "22.100"),
        Symbol(symbol: "MWG", price: "30.500"),
        Symbol(symbol: "MPB", price: "22.800"),
        Symbol(symbol: "AGB", price: "19.300"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        tableView.register(cellType: SymbolTableViewCell.self)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SymbolTableViewCell.self)
        let symbolData = symbols[indexPath.row]
        let price = Double(symbolData.price) ?? 0.0
        let priceColor: UIColor = price > 20.0 ? .redStock : .greenStock
        cell.setContent(sympol: symbolData.symbol, price: symbolData.price, textColor: priceColor)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChartView", sender: nil)
    }
}

extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChartView" {
        }
    }
}


struct Symbol {
    let symbol: String
    let price: String
}
