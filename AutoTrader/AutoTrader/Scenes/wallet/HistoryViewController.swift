//
//  HistoryViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 10/06/2024.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let walletRepository: WalletRepositoryType = WalletRepository(apiService: .shared)

    var walletID: Int?
    var listHistory: [History] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getListNoti()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.register(cellType: HistoryTableViewCell.self)
    }
}

extension HistoryViewController {
    private func getListNoti() {
        guard let walletID = walletID else { return }
        walletRepository.getHistory(walletID: walletID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listHistory):
                DispatchQueue.main.async {
                    self.listHistory = listHistory
                    self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "ERROR", message: "No data response")
                }
            }
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HistoryTableViewCell.self)
        let historyItem = listHistory[indexPath.row]
        cell.setContent(history: historyItem)
        return cell
    }
}
