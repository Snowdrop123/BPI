//
//  Transaction.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct Transaction {
    var date: Date
    var id: Int
    var price: Double
    var type: TransactionType
    var amount: Double
    
    var amountText: String {
        "\(amount) BTC" 
    }
    
    var dateText: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateformatter.string(from: date)
    }
    
    enum TransactionType: Int {
        case buy = 0
        case sell = 1
        
        var text: String {
            switch self {
            case .buy: return "Покупка"
            case .sell: return "Продажа"
            }
        }
    }
    
    init?(response: GetTransactionsResponse) {
        
        guard let id = Int(response.tid),
            let doubleDate = Double(response.date),
            let doublePrice = Double(response.price),
            let type = Int(response.type),
            let transactionType = TransactionType(rawValue: type),
            let doubleAmount = Double(response.amount) else {
            return nil
        }
        
        self.date = Date(timeIntervalSince1970: TimeInterval(doubleDate))
        self.id = id
        self.price = doublePrice
        self.type = transactionType
        self.amount = doubleAmount
    }
    
}
