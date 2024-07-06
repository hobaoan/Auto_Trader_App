//
//  WalletViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit
import MaterialActivityIndicator

final class WalletViewController: UIViewController {
    @IBOutlet weak var viewSum: UIView!
    @IBOutlet weak var viewProfit: UIView!
    @IBOutlet weak var viewSur: UIView!
    @IBOutlet weak var viewCapital: UIView!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var percent: UILabel!
    
    private let indicator = MaterialActivityIndicatorView()
    private let walletRepository: WalletRepositoryType = WalletRepository(apiService: .shared)
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    let notificationManager = NotificationManager.shared
    
    @IBOutlet weak var collectionView: UICollectionView!
    var userID: Int?
    var walletID: Int?
    var listStockHold: [StockHold] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchWalletData()
        fetchListStockHold()
        configCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(walletDataDidUpdate), name: .walletDataDidUpdate, object: nil)
    }
    
    @objc private func walletDataDidUpdate() {
        fetchWalletData()
        getListNoti()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .walletDataDidUpdate, object: nil)
    }
    
    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.register(cellType: StockHoldCollectionViewCell.self)
    }
}

extension WalletViewController {
    private func fetchWalletData() {
        guard let userID = userID else { return }
        indicator.startAnimating()
        walletRepository.getWallet(userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let walletData):
                DispatchQueue.main.async {
                    self.walletID = walletData.id
                    self.setContent(wallet: walletData)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.indicator.stopAnimating()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                }
            }
        }
    }
    
    private func getListNoti() {
        guard let userID = userID else { return }
        walletRepository.getListNoti(userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listNoti):
                DispatchQueue.main.async {
                    if let firstNotification = listNoti.first {
                        self.notificationManager.scheduleNotification(title: firstNotification.title,
                                                                      contentNoti: firstNotification.descriptionNoti)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                }
            }
        }
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

extension WalletViewController: UICollectionViewDataSource {
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


// MARK: - Handle button

extension WalletViewController {
    @IBAction func depositButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let actionWalletViewController = storyboard.instantiateViewController(withIdentifier: "ActionWalletViewController") as? ActionWalletViewController {
            actionWalletViewController.titleText = "Deposit"
            actionWalletViewController.walletID = self.walletID
            if let sheet = actionWalletViewController.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    return 200
                })]
            }
            present(actionWalletViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func withdrawButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let actionWalletViewController = storyboard.instantiateViewController(withIdentifier: "ActionWalletViewController") as? ActionWalletViewController {
            actionWalletViewController.titleText = "Withdraw"
            actionWalletViewController.walletID = self.walletID
            if let sheet = actionWalletViewController.sheetPresentationController {
                sheet.detents = [.custom(resolver: { context in
                    return 200
                })]
            }
            present(actionWalletViewController, animated: true, completion: nil)
        }
    }
}



// MARK: - setup UI

extension WalletViewController {
    private func setContent(wallet: Wallet) {
        total.text = "\(wallet.total.formattedWithSeparator() ?? "0") VND"
        profit.text = "\(wallet.profit.formattedWithSeparator() ?? "0") VND"
        capital.text = "\(wallet.capital.formattedWithSeparator() ?? "0") VND"
        balance.text = "\(wallet.balance.formattedWithSeparator() ?? "0") VND"
        percent.text = "\(wallet.percentProfit) %"
        if wallet.percentProfit >= 0 {
            percent.textColor = .greenStock
        } else {
            percent.textColor = .redStock
        }
    }
    
    private func setupUI() {
        setCorner(view: viewSum)
        setCorner(view: viewProfit)
        setCorner(view: viewSur)
        setCorner(view: viewCapital)
        view.setupIndicator(indicator)
    }
    
    private func setCorner(view: UIView) {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
}

extension Foundation.Notification.Name {
    static let walletDataDidUpdate = Foundation.Notification.Name("walletDataDidUpdate")
}

extension WalletViewController {
    @IBAction func listNotiButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toListNotiView", sender: nil)
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toHistoryView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListNotiView" {
            if let listNotiViewController = segue.destination as? ListNotiViewController {
                guard let userID = userID else { return }
                listNotiViewController.userID = userID
            }
        }
        
        if segue.identifier == "toHistoryView" {
            if let historyViewController = segue.destination as? HistoryViewController {
                guard let walletID = walletID else { return }
                historyViewController.walletID = walletID
            }
        }
    }
}
