//
//  NetworkError.swift
//  AutoTrader
//
//  Created by An Bảo on 27/04/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case mappingFailed
}
