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
    let notificationManager = NotificationManager.shared
    var userID: Int?
    var listStockHold: [StockHold] = []
    private var selectedIndexPath: IndexPath?
    var blurEffectView: UIVisualEffectView?
    var stockData: StockSearch?
    var stockId: Int?

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
        self.stockId = symbol.id
        searchBar.text = symbol.name
    }
    
    private func fetchDataStockBuy(id: Int) {
        stockRepository.getSearchResult(id: id) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.stockData = result
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
    
    private func orderStockPost(stockData: StockSearch) {
        guard let userID = userID else { return }
        guard let stockId = stockId else { return }

        let parameters: [String: Any] = [
            "symbol": stockData.symbol,
              "type": "Sell",
              "quantity": quantityTextField.text ?? "0",
              "price": stockData.todayPrice,
              "triggerPrice": stockData.todayPrice,
              "userId": userID,
              "stockInforId": stockId
        ]
        
        stockRepository.orderStock(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.notificationManager.scheduleNotification(title: "Sell success",
                                                                  contentNoti: "\(stockData.symbol) - Quantity: \(self.quantityTextField.text ?? "0") - Price: \(stockData.todayPrice) VND")
                    self.fetchListStockHold()
                case .failure(_):
                    self.showAlert(title: "ERROR", message: "Your \(stockData.symbol) stock quantity not enough to sell")
                }
            }
        }
    }
}

extension SellViewController {
    @IBAction func clearButtonTapped(_ sender: Any) {
        quantityTextField.text = ""
    }
    @IBAction func reviewButtonTapped(_ sender: Any) {
        if quantityTextField.text?.isEmpty == true
            || marketPriceTextField.text?.isEmpty == true
            || lastPriceLabel.text?.isEmpty == true {
                self.showAlert(title: "ERROR", message: "Input cannot be empty!")
        } else {
            showPopup()
        }
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
        self.stockId = selectedStockHold.stockId
        searchBar.text = selectedStockHold.stockSymbol
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? StockHoldCollectionViewCell {
            currentCell.setColorSelected(color: .darkGray)
        }
        selectedIndexPath = indexPath
    }
}

extension SellViewController: PopupViewControllerDelegate {
    private func showPopup() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView!)
        let popupVC = PopupViewController(nibName: "PopupViewController", bundle: nil)
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        let price = stockData?.todayPrice.formattedWithSeparator() ?? "N/A"
        present(popupVC, animated: true, completion: nil)
        popupVC.setContent(sympol: stockData?.symbol ?? "N/A",
                           price: "\(price) VND",
                           quantity: quantityTextField.text ?? "N/A",
                           status: "Sell")
    }
    
    func popupViewControllerDidDismiss() {
        blurEffectView?.removeFromSuperview()
        guard let stockData = stockData else { return }
        orderStockPost(stockData: stockData)
    }
}


