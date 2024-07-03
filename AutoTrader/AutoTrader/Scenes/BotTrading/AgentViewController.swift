//
//  AgentViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 29/05/2024.
//

import UIKit
import ProgressHUD

final class AgentViewController: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var startDay: UILabel!
    @IBOutlet weak var middleDay: UILabel!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var startPrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    @IBOutlet weak var middlePrice: UILabel!
    
    @IBOutlet weak var strategyButton: UIButton!
    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var currentDay: String?
    var futureDay: String?
    var amount: String?
    private var agentDatas: [Agent] = []
    private var currentAgentDatas: [Agent] = []
    private let progressAnimate = ProgressAnimate()
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postRequest(strategy: "normal")
        setupButton()
        configTableView()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(cellType: AgentTableViewCell.self)
    }
}

extension AgentViewController {
    private func postRequest(strategy: String) {
        progressAnimate.simulateProgress {}

        let parameters: [String: Any] = [
            "UserId": 11,
            "symbol": "ACB",
            "from_date": "2023-05-21",
            "to_date": "2024-05-21",
            "init_money": 1000000,
            "strategy": strategy
        ]

        stockRepository.postTradeRange(parameters: parameters) { [weak self] (result: Result<[Agent?]?, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let agentsOptional):
                if let agents = agentsOptional {
                    let validAgents = agents.compactMap { $0 }
                    self.agentDatas = validAgents
                    self.currentAgentDatas = self.agentDatas
                    DispatchQueue.main.async {
                        self.configChart(agents: self.agentDatas)
                        self.tableView.reloadData()
                        self.setupLabelChart()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", message: "There was a problem with the Bot Trading")
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "There was a problem with the Bot Trading")
                }
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
                
        let startDayText = DateHelper.convertDate(dateString: firstDay)
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
    
    private func setupButton() {
        strategyButton.menu = createMenuStrategy()
        strategyButton.showsMenuAsPrimaryAction = true
        
        FilterButton.menu = createMenuFilter()
        FilterButton.showsMenuAsPrimaryAction = true
    }
    
    private func createMenuStrategy() -> UIMenu {
        let normal = UIAction(title: "Normal") { [weak self] _ in
            self?.postRequest(strategy: "normal")
        }
        
        let dsa = UIAction(title: "DCA") { [weak self] _ in
            self?.postRequest(strategy: "DCA")
        }
        let lss = UIAction(title: "LSS") { [weak self] _ in
            self?.postRequest(strategy: "LSS")
        }
        
        let menu = UIMenu(children: [normal, dsa, lss])
        
        return menu
    }
}

extension AgentViewController {
    private func createMenuFilter() -> UIMenu {
        let allPoint = UIAction(title: "All") { [weak self] _ in
            guard let self = self else { return }
            self.filterTableView(by: 0)
        }
        
        let buyPoint = UIAction(title: "Buy point") { [weak self] _ in
            guard let self = self else { return }
            self.filterTableView(by: 1)
        }
        
        let sellPoint = UIAction(title: "Sell point") { [weak self] _ in
            guard let self = self else { return }
            self.filterTableView(by: 2)
        }
        
        let menu = UIMenu(children: [allPoint, buyPoint, sellPoint])
        return menu
    }
    
    private func filterTableView(by action: Int) {
        if action == 1 {
            currentAgentDatas = agentDatas.filter { $0.action == 1 }
        } else if action == 2 {
            currentAgentDatas = agentDatas.filter { $0.action == 2 }
        } else {
            currentAgentDatas = agentDatas
        }
        tableView.reloadData()
    }
}

extension AgentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAgentDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTableViewCell", for: indexPath) as! AgentTableViewCell
        let agentData = currentAgentDatas[indexPath.row]
        if agentData.action == 1 {
            cell.setContent(date: agentData.date,
                            price: agentData.close.formattedWithSeparator() ?? "N/A",
                            signal: "Buy",
                            color: .greenStock)
        }
        else {
            cell.setContent(date: agentData.date,
                            price: agentData.close.formattedWithSeparator() ?? "N/A",
                            signal: "Sell",
                            color: .redStock)
        }
        return cell
    }
}
