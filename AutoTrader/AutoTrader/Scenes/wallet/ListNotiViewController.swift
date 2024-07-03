//
//  ListNotiViewController.swift
//  AutoTrader
//
//  Created by An Bảo on 09/06/2024.
//

import UIKit

final class ListNotiViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let walletRepository: WalletRepositoryType = WalletRepository(apiService: .shared)
    var userID: Int?
    private var listNoti: [Noti] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getListNoti()
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: NotificationTableViewCell.self)
    }
}

extension ListNotiViewController {
    private func getListNoti() {
        guard let userID = userID else { return }
        walletRepository.getListNoti(userId: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let listNoti):
                DispatchQueue.main.async {
                    self.listNoti = listNoti
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

extension ListNotiViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNoti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NotificationTableViewCell.self)
        let notiItem = listNoti[indexPath.row]
        cell.setContent(noti: notiItem)
        return cell
    }
}

extension ListNotiViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notiID = listNoti[indexPath.row].id
            walletRepository.deleNoti(notiID: notiID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self.listNoti.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "ERROR", message: "Failed to delete notification: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
