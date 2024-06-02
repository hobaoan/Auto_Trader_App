//
//  AgentViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 29/05/2024.
//

import UIKit

final class AgentViewController: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    
    var currentDay: String?
    var futureDay: String?
    var amount: String?
    private var agentDatas: [Agent] = []
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    private var lineChart: SimpleLineChart!
    
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
