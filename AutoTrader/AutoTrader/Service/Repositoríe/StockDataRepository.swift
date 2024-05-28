//
//  StockDataRepository.swift
//  AutoTrader
//
//  Created by An Bảo on 27/05/2024.
//

import Foundation

protocol StockDataRepositoryType {
    func getListStock(completion: @escaping(Result<[Stock], Error>) -> Void)
    func getStockWithSympol(sympol: String, completion: @escaping(Result<Stock, Error>) -> Void)
    func getStockWithTime(sympol: String, startDay: String, endDay: String, completion: @escaping(Result<Stock, Error>) -> Void)
}

struct StockDataRepository: StockDataRepositoryType {
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func getListStock(completion: @escaping(Result<[Stock], Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor/GetList"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getStockWithSympol(sympol: String, completion: @escaping (Result<Stock, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor?Symbol=\(sympol)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getStockWithTime(sympol: String, startDay: String, endDay: String, completion: @escaping (Result<Stock, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor?Symbol=\(sympol)&startDay=\(startDay)&endDay=\(endDay)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
}
