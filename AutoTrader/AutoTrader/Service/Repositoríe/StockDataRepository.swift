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
    func postTradeRange(parameters: [String: Any], completion: @escaping(Result<[Agent?]?, Error>) -> Void)
    func getForecastData(nameML: String, sympol: String, completion: @escaping(Result<[Forecast], Error>) -> Void)
    func getStockInfo(id: Int, completion: @escaping(Result<StockInfo, Error>) -> Void)
    func getStockHold(usedID: Int, completion: @escaping(Result<[StockHold], Error>) -> Void)
    func getSearchStock(sympol: String, completion: @escaping (Result<[SympolSearch], any Error>) -> Void)
    func getSearchResult(id: Int, completion: @escaping(Result<StockSearch, Error>) -> Void)
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
    
    func postTradeRange(parameters: [String: Any], completion: @escaping (Result<[Agent?]?, Error>) -> Void) {
        let urlString = "https://rl.ftisu.vn/trade_range"
        apiService.postData(urlString: urlString, parameters: parameters, completion: completion)
    }
    
    func getForecastData(nameML: String, sympol: String, completion: @escaping (Result<[Forecast], any Error>) -> Void) {
        let urlString = "https://rl.ftisu.vn/\(nameML)Predict?Symbol=\(sympol)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getStockInfo(id: Int, completion: @escaping (Result<StockInfo, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor/stockInforId?stockinforId=\(id)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getStockHold(usedID: Int, completion: @escaping (Result<[StockHold], any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockHold/UserId?userId=\(usedID)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getSearchStock(sympol: String, completion: @escaping (Result<[SympolSearch], any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor/Search/symbol?symbol=\(sympol)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
    
    func getSearchResult(id: Int, completion: @escaping (Result<StockSearch, any Error>) -> Void) {
        let urlString = "https://app-trading-stock.azurewebsites.net/StockInfor/Daily/stockInforId?stockinforId=\(id)"
        apiService.fetchData(urlString: urlString, completion: completion)
    }
}
