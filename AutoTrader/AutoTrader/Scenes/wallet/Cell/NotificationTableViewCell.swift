//
//  NotificationTableViewCell.swift
//  AutoTrader
//
//  Created by An Bảo on 09/06/2024.
//

import UIKit
import Reusable

final class NotificationTableViewCell: UITableViewCell, NibReusable{

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        cellView.layer.cornerRadius = 15
        cellView.clipsToBounds = true
    }
    
    func setContent(noti: Noti) {
        titleLabel.text = noti.title
        contentLabel.text = noti.descriptionNoti
    }
}
