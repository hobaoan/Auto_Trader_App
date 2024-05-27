//
//  BotViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 19/05/2024.
//

import UIKit
import DatePicker

final class BotViewController: UIViewController {
    
    private let datePicker = DatePicker()
    private let today = Date()
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var timeEnd: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimeStart()
    }
}

extension BotViewController {
    private func setupTimeStart() {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: today)
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        
        let formattedDate = String(format: "%02d/%02d/%04d", day, month, year)
        timeStart.text = formattedDate
    }
    
    private func isEndDateValid(endDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let startDate = dateFormatter.date(from: timeStart.text ?? ""),
              let endDate = dateFormatter.date(from: endDate) else {
            return false
        }
        
        return endDate >= startDate
    }
}

extension BotViewController {
    @IBAction func buttonTapped(_ sender: UIButton) {
        datePicker.setupYearless { (selected, month, day) in
            if selected, let day = day, let month = month {
                let currentYear = Calendar.current.component(.year, from: Date())
                let formattedDate = String(format: "%02d/%02d/%04d", day, month, currentYear)
                if self.isEndDateValid(endDate: formattedDate) {
                    self.timeEnd.text = formattedDate
                } else {
                    self.showAlert(title: "Invalid Date", message: "End date cannot be before start date")
                }
            } else {
            }
        }
        datePicker.show(in: self, on: sender)
    }
    
    @IBAction func investButtonTapped(_ sender: Any) {
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
}
