//
//  PredictTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 20/05/2024.
//

import UIKit
import Reusable

final class PredictTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var anomalyImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
    }
    
    func setContent(date: String, price: String, anomalyImage: UIImage?) {
        dateLabel.text = date
        priceLabel.text = price
        anomalyImageView.image = anomalyImage
    }
}
