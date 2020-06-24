//
//  TransactionTableViewCell.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TransactionTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with transaction: Transaction) {
        accessoryType = .disclosureIndicator

        textLabel?.numberOfLines = 2
        textLabel?.text = """
        \(transaction.amountText)
        \(transaction.dateText)
        """

        detailTextLabel?.textAlignment = .center
        detailTextLabel?.text = transaction.type.text
    }
    
}
