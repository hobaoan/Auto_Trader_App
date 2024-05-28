//
//  Double+Extension.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import Foundation

extension Double {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}
