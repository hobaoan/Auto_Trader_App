//
//  Notification.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import Foundation
import ObjectMapper

struct Notification {
    var id: Int
    var title: String
    var descriptionNoti: String
    var createAt: String
    var userId: Int
}

extension Notification: Mappable {
    init?(map: Map) {
        id = 0
        title = ""
        descriptionNoti = ""
        createAt = ""
        userId = 0
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        descriptionNoti <- map["description"]
        createAt <- map["createAt"]
        userId <- map["userId"]
    }
}
