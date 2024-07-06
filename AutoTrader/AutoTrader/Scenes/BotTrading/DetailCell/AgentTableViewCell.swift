//
//  AgentTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 26/06/2024.
//

import UIKit
import Reusable

final class AgentTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
    }
    
    func setContent(date: String, price: String, signal: String, color: UIColor, status: String) {
        dateLabel.text = date
        priceLabel.text = price
        signalLabel.text = signal
        signalLabel.textColor = color
        statusLabel.text = status
    }
}
