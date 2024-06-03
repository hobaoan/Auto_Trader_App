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
    
    private let indicator = MaterialActivityIndicatorView()
    private let walletRepository: WalletRepositoryType = WalletRepository(apiService: .shared)

    var userID: Int?
    var walletID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchWalletData()
        NotificationCenter.default.addObserver(self, selector: #selector(walletDataDidUpdate), name: .walletDataDidUpdate, object: nil)

    }
    
    @objc private func walletDataDidUpdate() {
        fetchWalletData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .walletDataDidUpdate, object: nil)
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
                self.showAlert(title: "ERROR", message: "No data response")
            }
        }
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
        total.text = "\(wallet.total) VND"
        profit.text = "\(wallet.profit) VND"
        capital.text = "\(wallet.capital) VND"
        balance.text = "\(wallet.balance) VND"
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
