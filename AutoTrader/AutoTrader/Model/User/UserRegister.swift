//
//  User.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import Foundation
import ObjectMapper

struct UserRegister {
    var lastName: String
    var firstName: String
    var email: String
    var phoneNumber: String
    var dateOfBirth: String
    var regional: String
    var gender: String
    var address: String
    var password: String
}

extension UserRegister: Mappable {
    init?(map: Map) {
        lastName = ""
        firstName = ""
        email = ""
        phoneNumber = ""
        dateOfBirth = ""
        regional = ""
        gender = ""
        address = ""
        password = ""
    }
    
    mutating func mapping(map: Map) {
        lastName <- map["lastName"]
        firstName <- map["firstName"]
        email <- map["email"]
        phoneNumber <- map["phoneNumber"]
        dateOfBirth <- map["dateOfBirth"]
        regional <- map["regional"]
        gender <- map["gender"]
        address <- map["address"]
        password <- map["password"]
    }
}
