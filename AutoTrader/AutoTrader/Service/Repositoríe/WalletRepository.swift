//
//  WalletRepository.swift
//  AutoTrader
//
//  Created by An Bảo on 03/06/2024.
//

import Foundation

protocol WalletRepositoryType {
    func getWallet(userId: Int, completion: @escaping(Result<Wallet, Error>) -> Void)
    func putWallet(parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
}

struct WalletRepository: WalletRepositoryType {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getWallet(userId: Int, completion: @escaping (Result<Wallet, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/Wallet?UserId=\(userId)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func putWallet(parameters: [String : Any], completion: @escaping (Result<Void, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/Wallet"
        apiService.putData(urlString: urlString, parameters: parameters, completion: completion)
    }
}

