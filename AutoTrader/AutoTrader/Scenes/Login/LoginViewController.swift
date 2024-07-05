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
    
    private let userRepository: UserRepositoryType = UserRepository(apiService: .shared)
    private var userID = 0
    private var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK: - Check input

extension LoginViewController {
    private func checkLogin() -> Bool {
        guard let email = emailText.text, let password = passText.text else {
            self.showAlert(title: "ERROR", message: "Email and password cannot be empty")
            return false
        }
        
        if email.isEmpty {
            self.showAlert(title: "ERROR", message: "Email cannot be empty")
            return false
        }
        
        if password.isEmpty {
            self.showAlert(title: "ERROR", message: "Password cannot be empty")
            return false
        }
        
        if !isValidEmail(email) {
            self.showAlert(title: "ERROR", message: "Email format is wrong")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

// MARK: - Request login

extension LoginViewController {
    private func requestLogin(completion: @escaping (Bool) -> Void) {
        guard let email = emailText.text, !email.isEmpty,
              let password = passText.text, !password.isEmpty else {
            showAlert(title: "ERROR", message: "Email and Password cannot be empty.")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
        ]
        
        userRepository.getUser(parameters: parameters) { [weak self] (result: Result<Login, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let loginContent):
                    self.userID = loginContent.id
                    completion(true)
                case .failure(let error):
                    completion(false)
                    self.showAlert(title: "ERROR", message: "\(error)")
                }
            }
        }
    }
}

extension LoginViewController {
    @IBAction func buttonLoginTapped(_ sender: Any) {
        if checkLogin() == true {
            requestLogin { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.performSegue(withIdentifier: "toMainApp", sender: nil)
                } else {
                    self.showAlert(title: "Login failed", message: "The email or password is incorrect")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toMainApp":
            if let tabBarController = segue.destination as? UITabBarController {
                let viewControllers = tabBarController.viewControllers ?? []
                for viewController in viewControllers {
                    if let walletNavController = viewController as? UINavigationController {
                        if let listViewController = walletNavController.topViewController as? ListViewController {
                            listViewController.userID = self.userID
                        } else if let walletViewController = walletNavController.topViewController as? WalletViewController {
                            walletViewController.userID = self.userID
                        } else if let userViewController = walletNavController.topViewController as? UserViewController {
                            userViewController.userID = self.userID
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

// MARK: - setupUI

extension LoginViewController {
    private func setupUI() {
        configureTextField(textField: emailText)
        configurePasswordField(textField: passText)
    }
    
    private func configureTextField(textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
    }
    
    private func configurePasswordField(textField: UITextField) {
        configureTextField(textField: textField)
        textField.isSecureTextEntry = true
    }
}
