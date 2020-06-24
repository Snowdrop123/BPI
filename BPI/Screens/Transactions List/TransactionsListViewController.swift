//
//  TransactionsListViewController.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransactionsListViewController: UITableViewController {
    
    var transactionsDataSource: TransactionsDataProvider?

    init(transactionsDataSource: TransactionsDataProvider) {
        self.transactionsDataSource = transactionsDataSource
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleUpdateTransactionsList), for: .valueChanged)
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        
        getTransactions()
    }
    
    @objc func handleUpdateTransactionsList() {
        getTransactions()
    }
    
    func getTransactions() {

        transactionsDataSource?.getTransactions(completion: { [weak self] (result) in
            self?.refreshControl?.endRefreshing()
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
            case .failure(let error):
                print("error, ", error.localizedDescription)
            }
        })
    }
    
}

extension TransactionsListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("trn count, ", transactions.count)
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        cell.setup(with: transactions[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = TransactionDetailsViewController(transaction: transactions[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
