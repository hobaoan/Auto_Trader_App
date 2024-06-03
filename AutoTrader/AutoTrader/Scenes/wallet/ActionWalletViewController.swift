//
//  ActionWalletViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/06/2024.
//

import UIKit

final class ActionWalletViewController: UIViewController {
    
    @IBOutlet weak var walletInput: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let walletRepository: WalletRepositoryType = WalletRepository(apiService: .shared)
    var titleText: String?
    var walletID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContent(titleText: titleText ?? "Wallet")
    }
    
    private func setContent(titleText: String) {
        titleLabel.text = titleText
    }
}

extension ActionWalletViewController {
    @IBAction func startButtonTapped(_ sender: Any) {
        if validateWalletInput() {
            putWalletData()
        }
    }
    
    private func validateWalletInput() -> Bool {
        guard let inputText = walletInput.text, !inputText.isEmpty else {
            showAlert(title: "ERROR", message: "Wallet input cannot be empty.")
            return false
        }
        guard let walletAmount = Int(inputText), walletAmount >= 0 else {
            showAlert(title: "ERROR", message: "Wallet input must be a non-negative integer.")
            return false
        }
        return true
    }
}

extension ActionWalletViewController {
    private func putWalletData() {
        guard let status = titleText else { return }
        guard let walletID = walletID else { return }
        guard let inputText = walletInput.text else { return }
        
        let parameters: [String: Any] = [
            "id": walletID,
            "deposit": Int(inputText) ?? 0,
            "status": status
        ]
        
        walletRepository.putWallet(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .walletDataDidUpdate, object: nil)
                    self.dismiss(animated: true, completion: nil)
                case .failure(_):
                    self.showAlert(title: "ERROR", message: "Update wallet failed")
                }
            }
        }
    }
}
