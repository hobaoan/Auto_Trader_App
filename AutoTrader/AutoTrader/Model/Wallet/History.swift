//
//  history.swift
//  AutoTrader
//
//  Created by An Bảo on 09/06/2024.
//

import Foundation

struct History: Codable {
    let id: Int
    let deposit: Int
    let description: String
    let createAt: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case deposit
        case description
        case createAt = "createAt"
        case status
    }
}
