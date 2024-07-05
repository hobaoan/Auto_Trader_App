//
//  ActionTradingViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 03/07/2024.
//

import UIKit

protocol UserIdentifiable {
    var userID: Int? { get set }
}

final class ActionTradingViewController: UIViewController, CustomSegmentedControlDelegate {
    
    @IBOutlet weak var customSegmentedControl: CustomSegmentedControl! {
        didSet{
            customSegmentedControl.setButtonTitles(buttonTitles: ["Buy", "Sell",])
            customSegmentedControl.selectorViewColor = .systemOrange
            customSegmentedControl.selectorTextColor = .systemOrange
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    private var currentViewController: UIViewController?
    var userID: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        customSegmentedControl.delegate = self
        showViewController(withIdentifier: "BuyViewController")
    }
}

extension ActionTradingViewController {
    func change(to index:Int) {
        switch index {
        case 0:
            showViewController(withIdentifier: "BuyViewController")
        case 1:
            showViewController(withIdentifier: "SellViewController")
        default:
            break
        }
    }
    
    private func showViewController(withIdentifier identifier: String) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) else {
            return
        }
        
        if var userIdentifiableVC = viewController as? UserIdentifiable {
            userIdentifiableVC.userID = userID
        }
        
        currentViewController?.removeFromParent()
        currentViewController?.view.removeFromSuperview()
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        currentViewController = viewController
    }
}
