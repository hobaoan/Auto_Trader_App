//
//  RegisterViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 26/06/2024.
//

import UIKit

final class RegisterViewController: UIViewController {

    @IBOutlet weak var registerTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var regionalTF: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    private let userRepository: UserRepositoryType = UserRepository(apiService: .shared)
    private var gender = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupUI()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if validateTextFields() {
            DispatchQueue.main.async {
                self.postRequest()
            }
        }
    }
}

extension RegisterViewController {
    private func setupUI() {
        configureTextField(textField: registerTF)
        configureTextField(textField: firstNameTF)
        configureTextField(textField: emailTF)
        configureTextField(textField: phoneTF)
        configureTextField(textField: dobTF)
        configureTextField(textField: addressTF)
        configureTextField(textField: passwordTF)

    }
    private func configureTextField(textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
    }
    
    private func validateTextFields() -> Bool {
        let textFields = [registerTF, firstNameTF, emailTF, phoneTF, dobTF, regionalTF, addressTF, passwordTF]
        for textField in textFields {
            if textField?.text?.isEmpty ?? true {
                showAlert(title: "ERROR!", message: "Please fill in all fields.")
                return false
            }
        }
        return true
    }
}

extension RegisterViewController {
    private func setupButton() {
        genderButton.menu = createMenu()
        genderButton.showsMenuAsPrimaryAction = true
    }
    
    private func createMenu() -> UIMenu {
        let male = UIAction(title: "Male") { [weak self] _ in
            guard let self = self else { return }
            self.gender = "male"
            genderButton.setTitle("Male", for: .normal)
        }
        
        let female = UIAction(title: "Female") { [weak self] _ in
            guard let self = self else { return }
            self.gender = "female"
            genderButton.setTitle("Female", for: .normal)
        }
        
        let menu = UIMenu(children: [male, female])
        return menu
    }
}

extension RegisterViewController {
    private func postRequest() {
        guard let lastName = registerTF.text else { return }
        guard let firstName = firstNameTF.text else { return }
        guard let email = emailTF.text else { return }
        guard let phone = phoneTF.text else { return }
        guard let dob = dobTF.text else { return }
        guard let regional = regionalTF.text else { return }
        guard let address = addressTF.text else { return }
        guard let password = passwordTF.text else { return }

        let parameters: [String: Any] = [
            "lastName": lastName,
            "firstName": firstName,
            "email": email,
            "phoneNumber": phone,
            "dateOfBirth": dob,
            "regional": regional,
            "gender": self.gender,
            "address": address,
            "password": password
        ]

        userRepository.registerUser(parameters: parameters) { [weak self] (result: Result<User, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.showAlert(title: "SUCCESS", message: "Register account success!")
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure( let error ):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "\(error)")
                }
            }
        }
    }
}
