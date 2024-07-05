//
//  ViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 25/04/2024.
//

import UIKit
import Reusable
import MaterialActivityIndicator

final class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    private let indicator = MaterialActivityIndicatorView()
    private var stockDatas: [Stock] = []
    let notificationManager = NotificationManager.shared
    
    var userID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationManager.requestAuthorization()
        view.setupIndicator(indicator)
        configTableView()
        fetchStockData()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: SymbolTableViewCell.self)
    }
}

// MARK: - Handle data

extension ListViewController {
    private func fetchStockData() {
        indicator.startAnimating()
        stockRepository.getListStock { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stocks):
                self.stockDatas = stocks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.indicator.stopAnimating()
                    }
                }
            case .failure(_):
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SymbolTableViewCell.self)
        let stockData = stockDatas[indexPath.row]
        cell.setContent(stock: stockData)
        cell.setupChart(stockDatas: stockData.stockDatas)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toChartView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChartView" {
            if let chartViewController = segue.destination as? ChartViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                chartViewController.userID = self.userID
                let selectedStock = stockDatas[indexPath.row]
                chartViewController.symbol = selectedStock.symbol
            }
        }
    }
}
