//
//  UIView+Extension.swift
//  AutoTrader
//
//  Created by An Bảo on 29/05/2024.
//

import UIKit
import MaterialActivityIndicator

extension UIView {
    func setupIndicator(_ indicator: MaterialActivityIndicatorView) {
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
