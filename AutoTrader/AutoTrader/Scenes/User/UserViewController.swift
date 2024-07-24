//
//  UserViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 25/04/2024.
//

import UIKit

final class UserViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    var userID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UserViewController {
    @IBAction func logoutButtonTapped(_ sender: Any) {
        showAlert(title: "Confirmation", message: "Are you sure you want to log out?", okHandler: { action in
            self.performSegue(withIdentifier: "showLoginView", sender: nil)
        })
    }
}
