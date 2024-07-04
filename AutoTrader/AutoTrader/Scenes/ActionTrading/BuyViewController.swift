//
//  BuyViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import UIKit

final class BuyViewController: UIViewController {

    @IBOutlet weak var cellView1: UIView!
    @IBOutlet weak var cellView2: UIView!
    @IBOutlet weak var cellView3: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBOutlet weak var marketPriceTextfield: UITextField!
    
    private var searchController = UISearchController()
    private var stockSearchViewController = StockSearchViewController()
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        customizeSearchBar()
        setUpSearchController()
        searchBar.delegate = self
        searchController.searchResultsUpdater = self
        stockSearchViewController.delegate = self
    }
    
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: stockSearchViewController)
        definesPresentationContext = true
    }
}

extension BuyViewController {
    @IBAction func reivewButtonTapped(_ sender: Any) {
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
    }
}

extension BuyViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            stockSearchViewController.fetchResults(for: searchText)
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        present(searchController, animated: true, completion: nil)
    }
}

extension BuyViewController {
    private func setupUI(){
        setupCorner(view: cellView1)
        setupCorner(view: cellView2)
        setupCorner(view: cellView3)
    }
    
    private func setupCorner(view: UIView) {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    private func customizeSearchBar() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
            textField.tintColor = .opaqueSeparator
        }
    }
}

extension BuyViewController: StockSearchViewControllerDelegate {
    func stockSearchViewController(_ controller: StockSearchViewController, didSelectSymbol symbol: SympolSearch) {
        fetchDataStockBuy(id: symbol.id)
    }
    
    private func fetchDataStockBuy(id: Int) {
        stockRepository.getSearchResult(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if let todayPriceString = result.todayPrice.formattedWithSeparator() {
                        self.lastPriceLabel.text = "\(todayPriceString) VND"
                        self.marketPriceTextfield.text = "\(todayPriceString) VND"
                    }
                    self.changeLabel.text = "\(result.percentChange) %"
                case .failure(_):
                    break
                }
            }
        }
    }
}
