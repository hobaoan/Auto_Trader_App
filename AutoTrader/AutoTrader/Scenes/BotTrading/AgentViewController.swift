//
//  AgentViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 29/05/2024.
//

import UIKit

final class AgentViewController: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var startDay: UILabel!
    @IBOutlet weak var middleDay: UILabel!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    @IBOutlet weak var middlePrice: UILabel!
    
    var currentDay: String?
    var futureDay: String?
    var amount: String?
    private var agentDatas: [Agent] = []
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postRequest()
    }
}

extension AgentViewController {
    private func postRequest() {
        let parameters: [String: Any] = [
            "UserId": 11,
            "symbol": "BSI",
            "from_date": "2023-05-21",
            "to_date": "2024-05-21",
            "init_money": 1000000,
            "strategy": "normal"
        ]
        
        stockRepository.postTradeRange(parameters: parameters) { [weak self] (result: Result<[Agent?]?, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let agentsOptional):
                if let agents = agentsOptional {
                    let validAgents = agents.compactMap { $0 }
                    self.agentDatas = validAgents
                    DispatchQueue.main.async {
                        self.configChart(agents: self.agentDatas)
                        self.setupLabelChart()
                    }
                } else {
                    self.showAlert(title: "ERROR", message: "There was a problem with the Bot Trading")
                }
            case .failure(let error):
                self.showAlert(title: "ERROR", message: "There was a problem with the Bot Trading")
            }
        }
    }
}

extension AgentViewController {
    private func setupLabelChart() {
        guard !agentDatas.isEmpty else {
            return
        }
        let firstStockData = agentDatas.first
        let middleIndex = agentDatas.count / 2
        let middleStockData = agentDatas[middleIndex]
        let lastStockData = agentDatas.last
        
        let startPriceText = firstStockData?.close.formattedWithSeparator() ?? ""
        let middlePriceText = middleStockData.close.formattedWithSeparator()
        let endPriceText = lastStockData?.close.formattedWithSeparator() ?? ""
        
        self.startPrice.text = startPriceText
        self.middlePrice.text = middlePriceText
        self.endPrice.text = endPriceText
        
        guard let firstDay = firstStockData?.date else { return }
        guard let lastDay = lastStockData?.date else { return }
        
        print(firstDay)
        
        let startDayText = DateHelper.convertDate(dateString: firstDay)
        print(startDayText)
        let middleDayText = DateHelper.convertDate(dateString: middleStockData.date)
        let endDayText = DateHelper.convertDate(dateString: lastDay)
        
        self.startDay.text = startDayText
        self.middleDay.text = middleDayText
        self.endDay.text = endDayText
    }
}

extension AgentViewController {
    private func configChart(agents: [Agent]) {
        ConfigureChart.configureChartAgent (
            in: chartView,
            with: agents,
            lineColor: .blueStock,
            agentSizePoint: 10.0,
            lineShadowGradientStart: .blueShadow,
            lineShadowGradientEnd: .greyCustom
        )
    }
}
