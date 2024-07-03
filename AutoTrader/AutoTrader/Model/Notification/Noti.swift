//
//  Notification.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import Foundation

struct Noti: Codable {
    var id: Int
    var title: String
    var descriptionNoti: String
    var createAt: String?
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptionNoti = "description"
        case createAt
        case userId
    }
}
