//
//  WalletViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import UIKit

final class WalletViewController: UIViewController {

    @IBOutlet weak var viewSum: UIView!
    @IBOutlet weak var viewProfit: UIView!
    @IBOutlet weak var viewSur: UIView!
    @IBOutlet weak var viewCapital: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - setup UI

extension WalletViewController {
    private func setupUI() {
        setCorner(view: viewSum)
        setCorner(view: viewProfit)
        setCorner(view: viewSur)
        setCorner(view: viewCapital)
    }
    
    private func setCorner(view: UIView) {
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
}
