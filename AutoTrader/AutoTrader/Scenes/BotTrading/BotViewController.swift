//
//  BotViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 19/05/2024.
//

import UIKit
import DatePicker

protocol BotViewControllerDelegate: AnyObject {
    func botViewControllerDidDismiss(currentDay: String, futureDay: String, amount: String, model: String)
}

final class BotViewController: UIViewController {
    
    weak var delegate: BotViewControllerDelegate?
    
    private let datePicker = DatePicker()
    private let today = Date()
    private var currentDay = ""
    private var futureDay = ""
    private var model = ""

    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var timeEnd: UILabel!
    
    let minDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 2005)!
    let maxDate = DatePickerHelper.shared.dateFrom(day: 01, month: 01, year: 2025)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
}

extension BotViewController {
    private func isEndDateValid(endDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let startDate = dateFormatter.date(from: timeStart.text ?? ""),
              let endDate = dateFormatter.date(from: endDate) else {
            return false
        }
        
        return endDate >= startDate
    }
    
    private func checkInput() -> Bool {
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            showAlert(title: "Invalid Input", message: "Input cannot be empty")
            return false
        }
        
        guard isValidPositiveNumber(amountText) else {
            showAlert(title: "Invalid Input", message: "Amount must be a positive number")
            return false
        }
        
        if timeEnd.text?.isEmpty ?? true {
            showAlert(title: "Invalid Input", message: "Input cannot be empty")
            return false
        }
        
        return true
    }
    
    private func isValidPositiveNumber(_ text: String) -> Bool {
        if let amount = Double(text), amount > 0 {
            return true
        }
        return false
    }
}

extension BotViewController {
    @IBAction func timeStartButtonTapped(_ sender: UIButton) {
        let today = Date()
        let datePicker = DatePicker()
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day, .month, .year], from: selectedDate)
                if let day = components.day, let month = components.month, let year = components.year {
                    let formattedDate = String(format: "%02d/%02d/%04d", day, month, year)
                    self.timeStart.text = formattedDate
                    let formattedDateForAgent = self.formatDateForDisplay(date: selectedDate)
                    self.currentDay = formattedDateForAgent
                }
            } else {
            }
        }
        datePicker.show(in: self, on: sender)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        let today = Date()
        let datePicker = DatePicker()
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day, .month, .year], from: selectedDate)
                if let day = components.day, let month = components.month, let year = components.year {
                    let formattedDate = String(format: "%02d/%02d/%04d", day, month, year)
                    if self.isEndDateValid(endDate: formattedDate) {
                        self.timeEnd.text = formattedDate
                        let formattedDateForAgent = self.formatDateForDisplay(date: selectedDate)
                        self.futureDay = formattedDateForAgent

                    } else {
                        self.showAlert(title: "Invalid Date", message: "End date cannot be before start date")
                    }
                }
            } else {
            }
        }
        datePicker.show(in: self, on: sender)
    }
}

extension BotViewController {
    @IBAction func investButtonTapped(_ sender: Any) {
        if checkInput() {
            let amountText = amountTextField.text ?? "0"
            dismiss(animated: true) {
                self.delegate?.botViewControllerDidDismiss(currentDay: self.currentDay,
                                                           futureDay: self.futureDay,
                                                           amount: amountText, 
                                                           model: self.model)
            }
        }
    }
}

extension BotViewController {
    private func setupUI() {
        amountTextField.layer.cornerRadius = 10
        amountTextField.clipsToBounds = true
        timeStart.layer.cornerRadius = 10
        timeStart.clipsToBounds = true
        timeEnd.layer.cornerRadius = 10
        timeEnd.clipsToBounds = true
    }
    
    private func setupButton() {
        modelButton.menu = createMenuModel()
        modelButton.showsMenuAsPrimaryAction = true
        self.modelButton.setTitle("None", for: .normal)
    }
    
    private func createMenuModel() -> UIMenu {
        
        let none = UIAction(title: "None") { [weak self] _ in
            guard let self = self else { return }
            self.modelButton.setTitle("None", for: .normal)
            self.model = ""
        }
        
        let lstm = UIAction(title: "LSTM") { [weak self] _ in
            guard let self = self else { return }
            self.modelButton.setTitle("LSTM", for: .normal)
            self.model = "LSTM"
        }
        
        let attention = UIAction(title: "Attention") { [weak self] _ in
            guard let self = self else { return }
            self.modelButton.setTitle("Attention", for: .normal)
            self.model = "LSTM"
        }
        
        let menu = UIMenu(children: [none, lstm, attention])
        
        return menu
    }
    
    private func formatDateForDisplay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

}
