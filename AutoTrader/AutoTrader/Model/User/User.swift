//
//  User.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import Foundation
import ObjectMapper

struct User {
    var id: Int
    var lastName: String
    var firstName: String
    var email: String
    var phoneNumber: String
    var dateOfBirth: String
    var regional: String
    var gender: String
    var address: String
    var createAt: String
}

extension User: Mappable {
    init?(map: Map) {
        id = 0
        lastName = ""
        firstName = ""
        email = ""
        phoneNumber = ""
        dateOfBirth = ""
        regional = ""
        gender = ""
        address = ""
        createAt = ""
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        lastName <- map["lastName"]
        firstName <- map["firstName"]
        email <- map["email"]
        phoneNumber <- map["phoneNumber"]
        dateOfBirth <- map["dateOfBirth"]
        regional <- map["regional"]
        gender <- map["gender"]
        address <- map["address"]
        createAt <- map["createAt"]
    }
}

