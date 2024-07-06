//
//  PopupViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 05/07/2024.
//

import UIKit

protocol PopupViewControllerDelegate: AnyObject {
    func popupViewControllerDidDismiss()
}

final class PopupViewController: UIViewController {

    weak var delegate: PopupViewControllerDelegate?
  
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var sympolLabel: UILabel!
    @IBOutlet weak var marketPrice: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        popupView.layer.cornerRadius = 20
        popupView.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.popupViewControllerDidDismiss()
        }
    }
    
    func setContent(sympol: String, price: String, quantity: String, status: String) {
        sympolLabel.text = sympol
        marketPrice.text = price
        quantityLabel.text = quantity
        statusLabel.text = status
    }
}
