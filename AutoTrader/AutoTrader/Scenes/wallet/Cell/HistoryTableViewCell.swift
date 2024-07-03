//
//  HistoryTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 09/06/2024.
//

import UIKit
import Reusable

final class HistoryTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
    }
    
    func setContent(history: History) {
        statusLabel.text = history.status
        descriptionLabel.text = history.description
    }
}
