//
//  ChartPricesCollectionViewCell.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChartPricesCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "ChartPricesCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        contentView.addSubview(label)
        label.pinEdges(to: contentView)
    }
    
    public func setup(with item: CoinAveragePrice) {
        let dateFrom = item.dateFrom.cellFormatString()
        let dateTo = item.dateTo.cellFormatString()
        guard dateFrom != dateTo else {
            label.numberOfLines = 2
            label.text = """
            \(Int(item.price))
            *\(dateTo)*
            """
            return
        }
        label.numberOfLines = 4
        label.text = """
        \(Int(item.price))
        *\(dateFrom)*
        -
        *\(dateTo)*
        """
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension Date {
    func cellFormatString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yy"
        return dateformatter.string(from: self)
    }
}
