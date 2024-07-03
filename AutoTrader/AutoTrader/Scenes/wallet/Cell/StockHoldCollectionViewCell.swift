//
//  StockHoldCollectionViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 10/06/2024.
//

import UIKit
import Reusable

final class StockHoldCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var sympolLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
    }

    func setContent(stockHold: StockHold) {
        sympolLabel.text = stockHold.stockSymbol
        totalLabel.text = stockHold.total.formattedWithSeparator()
        unitLabel.text = "\(stockHold.unit)"
        capitalLabel.text = stockHold.totalcapital.formattedWithSeparator()
        percentLabel.text = "\(Int(stockHold.percent)) %"
    }
}
