//
//  User.swift
//  AutoTrader
//
//  Created by An Bảo on 18/05/2024.
//

import Foundation

struct User: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case lastName = "lastName"
        case firstName = "firstName"
        case email = "email"
        case phoneNumber = "phoneNumber"
        case dateOfBirth = "dateOfBirth"
        case regional = "regional"
        case gender = "gender"
        case address = "address"
        case createAt = "createAt"
    }
}

