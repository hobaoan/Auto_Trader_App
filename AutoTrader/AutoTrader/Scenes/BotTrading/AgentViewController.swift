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
    
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var investmentLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    
    var currentDay: String?
    var futureDay: String?
    var amount: String?
    var model: String?
    var sympol: String?
    var userID: Int?
    
    private var agentDatas: [Agent] = []
    private var currentAgentDatas: [Agent] = []
    private let progressAnimate = ProgressAnimate()
    
    private let stockRepository: StockDataRepositoryType = StockDataRepository(apiService: .shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postRequest(strategy: "normal")
        setupButton()
        configTableView()
        setupUI()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.reloadData()
        tableView.register(cellType: AgentTableViewCell.self)
    }
    
    private func setupUI() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.white.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
        viewCustom.layer.addSublayer(topBorder)
        let bottomBorder = CALayer()
        bottomBorder.backgroundColor = UIColor.white.cgColor
        bottomBorder.frame = CGRect(x: 0, y: viewCustom.frame.height - 1, width: view.frame.width, height: 1)
        viewCustom.layer.addSublayer(bottomBorder)
    }
}

extension AgentViewController {
    private func postRequest(strategy: String) {
        progressAnimate.simulateProgress {}
        
        guard let userID = userID else { return }
        guard let sympol = sympol else { return }
        guard let currentDay = currentDay else { return }
        guard let futureDay = futureDay else { return }
        guard let amount = amount else { return }
        guard let model = model else { return }
        
        let parameters: [String: Any] = [
            "UserId": userID,
            "symbol": "\(sympol)",
            "from_date": "\(currentDay)",
            "to_date": "\(futureDay)",
            "init_money": Double(amount) ?? 0.0,
            "strategy": strategy,
            "model": "\(model)"
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
                        self.setContent()
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
        strategyButton.layer.cornerRadius = 5
        strategyButton.clipsToBounds = true
        
        FilterButton.menu = createMenuFilter()
        FilterButton.showsMenuAsPrimaryAction = true
        FilterButton.layer.cornerRadius = 5
        FilterButton.clipsToBounds = true
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
                            price: "\(agentData.close.formattedWithSeparator() ?? "N/A") VND",
                            signal: "Buy",
                            color: .greenStock, 
                            status: "Content: \(agentData.status)")
        }
        else if agentData.action == 2 {
            cell.setContent(date: agentData.date,
                            price: "\(agentData.close.formattedWithSeparator() ?? "N/A") VND",
                            signal: "Sell",
                            color: .redStock, 
                            status:  "Content: \(agentData.status)")
        } else {
            cell.setContent(date: agentData.date,
                            price: "\(agentData.close.formattedWithSeparator() ?? "N/A") VND",
                            signal: "Hold",
                            color: .systemOrange, 
                            status:  "Content: \(agentData.status)")
        }
            
        return cell
    }
}

extension AgentViewController {
    private func getBalance() -> Double {
        return agentDatas.last?.balance ?? 0.0
    }
    
    private func getInvestment() -> Double {
        let totalGain = getGain()
        let originBalance = agentDatas.first?.balance ?? 0.0
        return totalGain / originBalance * 100
    }
    
    private func getGain() -> Double {
        var totalGain: Double = 0.0
        for agentData in agentDatas {
            if agentData.action == 2 {
                if let gain = agentData.gain {
                    totalGain += gain
                }
            }
        }
        return totalGain
    }

    private func setContent() {
        balanceLabel.text = "\(getBalance())"
        let investment = getInvestment()
        investmentLabel.text = "\(investment) %"
        if investment < 0 {
            investmentLabel.textColor = .redStock
        } else {
            investmentLabel.textColor = .greenStock
        }
        let gain = getGain()
        gainLabel.text = "\(gain)"
        if gain < 0 {
            gainLabel.textColor = .redStock
        } else {
            gainLabel.textColor = .greenStock
        }
    }
}
