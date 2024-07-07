//
//  Double+Extension.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import Foundation

extension Double {
    func formattedWithSeparator() -> String? {
        let integerPart = Int(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: integerPart))
    }
    
    func roundedToTwoDecimalPlaces() -> Double {
        return (self * 100).rounded() / 100
    }
}
