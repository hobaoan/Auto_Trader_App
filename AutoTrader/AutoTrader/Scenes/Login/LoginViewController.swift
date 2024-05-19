//
//  LoginViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 27/04/2024.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var forgotPassLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension LoginViewController {
    @IBAction func buttonLoginTapped(_ sender: Any) {
    }
}

// MARK: - setupUI

extension LoginViewController {
    private func setupUI() {
        configureTextField(textField: emailText)
        configureTextField(textField: passText)
    }
    
    private func configureTextField(textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
    }
}
