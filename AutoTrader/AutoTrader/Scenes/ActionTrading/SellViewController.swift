//
//  SellViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import UIKit

final class SellViewController: UIViewController, UserIdentifiable {

    @IBOutlet weak var cellView1: UIView!
    @IBOutlet weak var cellView2: UIView!
    @IBOutlet weak var cellView3: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var marketPriceTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var searchController = UISearchController()
    private var stockSearchViewController = StockSearchViewController()
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    var userID: Int?
    var listStockHold: [StockHold] = []
    private var selectedIndexPath: IndexPath? // Add this property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        customizeSearchBar()
        setUpSearchController()
        configCollectionView()
        fetchListStockHold()
        searchBar.delegate = self
        searchController.searchResultsUpdater = self
        stockSearchViewController.delegate = self
    }
    
    func setUpSearchController() {
        searchController = UISearchController(searchResultsController: stockSearchViewController)
        definesPresentationContext = true
    }
    
    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: StockHoldCollectionViewCell.self)
    }
    
    private func fetchListStockHold() {
        guard let userID = userID else { return }
        stockRepository.getStockHold(usedID: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listStockHold):
                DispatchQueue.main.async {
                    self.listStockHold = listStockHold
                    self.collectionView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                }
            }
        }
    }
}

extension SellViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            stockSearchViewController.fetchResults(for: searchText)
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        present(searchController, animated: true, completion: nil)
    }
}

extension SellViewController {
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

extension SellViewController: StockSearchViewControllerDelegate {
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
                        self.marketPriceTextField.text = "\(todayPriceString) VND"
                    }
                    self.changeLabel.text = "\(result.percentChange) %"
                case .failure(_):
                    break
                }
            }
        }
    }
}

extension SellViewController {
    @IBAction func clearButtonTapped(_ sender: Any) {
    }
    @IBAction func reviewButtonTapped(_ sender: Any) {
    }
}

extension SellViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listStockHold.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: StockHoldCollectionViewCell.self)
        let stockHold = listStockHold[indexPath.row]
        cell.setContent(stockHold: stockHold)
        return cell
    }
}

extension SellViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            if let previousCell = collectionView.cellForItem(at: selectedIndexPath) as? StockHoldCollectionViewCell {
                previousCell.setColorSelected(color: .greyCell)
            }
        }
        
        let selectedStockHold = listStockHold[indexPath.row]
        fetchDataStockBuy(id: selectedStockHold.stockId)
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? StockHoldCollectionViewCell {
            currentCell.setColorSelected(color: .darkGray)
        }
        selectedIndexPath = indexPath
    }
}
