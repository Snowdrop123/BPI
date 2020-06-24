//
//  TransactionDetailsViewController.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController {
        
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.text = transaction.type.text
        }
    }
    @IBOutlet weak var amountLabel: UILabel! {
        didSet {
            amountLabel.text = "\(transaction.amountText)"
        }
    }
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "\(transaction.price)"
        }
    }
    @IBOutlet weak var idLabel: UILabel! {
        didSet {
            idLabel.text = "\(transaction.id)"
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = transaction.dateText
        }
    }
    
    let transaction: Transaction

    init(transaction: Transaction) {
        self.transaction = transaction
        super.init(nibName: "TransactionDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
