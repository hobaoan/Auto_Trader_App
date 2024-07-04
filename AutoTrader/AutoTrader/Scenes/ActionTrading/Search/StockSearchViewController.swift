//
//  StockSearchViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import UIKit

protocol StockSearchViewControllerDelegate: AnyObject {
    func stockSearchViewController(_ controller: StockSearchViewController, didSelectSymbol symbol: SympolSearch)
}

final class StockSearchViewController: UITableViewController {
    
    weak var delegate: StockSearchViewControllerDelegate?
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    private var searchResults: [SympolSearch] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    private func configTableView() {
        tableView.register(SympolCell.self, forCellReuseIdentifier: "SympolCell")
    }
    
    func fetchResults(for symbol: String) {
        stockRepository.getSearchStock(sympol: symbol) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let sympols):
                    self.searchResults = sympols
                    self.tableView.reloadData()
                case .failure(_):
                    break
                }
            }
        }
    }
    
    // TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SympolCell", for: indexPath) as! SympolCell
        let sympol = searchResults[indexPath.row]
        cell.setContent(sympolSearch: sympol)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedSymbol = searchResults[indexPath.row]
            delegate?.stockSearchViewController(self, didSelectSymbol: selectedSymbol)
            dismiss(animated: true, completion: nil)
        }
}
