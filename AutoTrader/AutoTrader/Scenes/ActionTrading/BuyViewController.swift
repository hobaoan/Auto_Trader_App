//
//  BuyViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import UIKit

final class BuyViewController: UIViewController, UserIdentifiable {

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
    let notificationManager = NotificationManager.shared
    var blurEffectView: UIVisualEffectView?
    var stockData: StockSearch?
    var userID: Int?
    var stockId: Int?

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
        if quantityTextfield.text?.isEmpty == true
            || marketPriceTextfield.text?.isEmpty == true
            || lastPriceLabel.text?.isEmpty == true {
                self.showAlert(title: "ERROR", message: "Input cannot be empty!")
        } else {
            showPopup()
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        quantityTextfield.text = ""
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
        searchBar.text = symbol.name
        self.stockId = symbol.id
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
                        self.marketPriceTextfield.text = "\(todayPriceString) VND"
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
              "type": "Buy",
              "quantity": quantityTextfield.text ?? "0",
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
                    self.notificationManager.scheduleNotification(title: "Buy success",
                                                                  contentNoti: "\(stockData.symbol) - Quantity: \(self.quantityTextfield.text ?? "0") - Price: \(stockData.todayPrice) VND")
                case .failure(let error):
                    self.showAlert(title: "ERROR", message: "\(error)")
                }
            }
        }
    }
}

extension BuyViewController: PopupViewControllerDelegate {
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
                           quantity: quantityTextfield.text ?? "N/A",
                           status: "Buy")
    }
    
    func popupViewControllerDidDismiss() {
        blurEffectView?.removeFromSuperview()
        guard let stockData = stockData else { return }
        orderStockPost(stockData: stockData)
    }
}


