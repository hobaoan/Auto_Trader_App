//
//  UserRepository.swift
//  AutoTrader
//
//  Created by An Bảo on 02/06/2024.
//

import Foundation

protocol UserRepositoryType {
    func getUser(parameters: [String: Any], completion: @escaping(Result<Login, Error>) -> Void)
}

struct UserRepository: UserRepositoryType {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getUser(parameters: [String : Any], completion: @escaping (Result<Login, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/api/Auth/login"
        apiService.postData(urlString: urlString, parameters: parameters, completion: completion)
    }
}
