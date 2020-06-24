//
//  TransactionsDataProvider.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class TransactionsDataProvider {
    
    var request: GetTransactionsRequest?
    
    init(getTransactionsRequest: GetTransactionsRequest) {
        self.request = getTransactionsRequest
    }
    
    func getTransactions(completion: @escaping (Result<[Transaction], Error>) -> ()) {
        request?.getTransactions(completion: { (result) in
            switch result {
            case .success(let response):
                var transactions = response.compactMap { item in Transaction(response: item) }
                if transactions.count > 500 {
                    transactions = Array(transactions[0..<500])
                }
                completion(.success(transactions))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}
