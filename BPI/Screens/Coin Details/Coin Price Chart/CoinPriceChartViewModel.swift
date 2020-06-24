//
//  CoinPriceChartViewModel.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

struct CoinAveragePrice {
    let price: Double
    let dateFrom: Date
    let dateTo: Date
}

struct CoinPriceChartViewModel {
    
    private let maxPriceDisplayAmount: Double?
    private let minPriceCutDisplayAmount: Double?
    
    var bpiCurrencyItems: (BPICurrency, BPICurrency)?
    private var averagePrices: [CoinAveragePrice]?
    
    init(averagePrices: [CoinAveragePrice]? = nil) {
        self.averagePrices = averagePrices
        
        let minPrice = (averagePrices?.min { $0.price < $1.price }?.price ?? 0.0)
        let maxPrice = (averagePrices?.max { $0.price < $1.price }?.price ?? 0.0)
        let priceRatio = minPrice / maxPrice
        
        if priceRatio > 0.96 {
            minPriceCutDisplayAmount = minPrice * 0.99
            maxPriceDisplayAmount = maxPrice * 1.01
        } else if priceRatio > 0.9 {
            minPriceCutDisplayAmount = minPrice * 0.98
            maxPriceDisplayAmount = maxPrice * 1.02
        } else {
            minPriceCutDisplayAmount = minPrice * 0.8
            maxPriceDisplayAmount = maxPrice * 1.06
        }
    }
    
    public var numberOfColumns: Int {
        averagePrices?.count ?? 0
    }
    
    public let maxPricePercentageRate: Int = 100
    
    public func shouldFillCell(at indexPath: IndexPath) -> Bool {
        guard let averagePrices = averagePrices,
            let maxPrice = maxPriceDisplayAmount,
            let minPrice = minPriceCutDisplayAmount else {
            return false
        }
        
        let item = averagePrices[indexPath.section]
        let price = item.price

        let fillPercentage = ((price - minPrice) / (maxPrice - minPrice)) * Double(maxPricePercentageRate)
        
        return (Int(fillPercentage) < (maxPricePercentageRate - indexPath.item)) ? true : false
    }
    
    public func item(at indexPath: IndexPath) -> CoinAveragePrice? {
        if let bpiCurrencyItems = bpiCurrencyItems {
            return getCurrencyAveragePrice(defaultBPICurrency: bpiCurrencyItems.0, newBpiCurrency: bpiCurrencyItems.1)?[indexPath.item]
        } else {
            return averagePrices?[indexPath.item]
        }
    }
    
    public func getCurrencyAveragePrice(defaultBPICurrency: BPICurrency, newBpiCurrency: BPICurrency) -> [CoinAveragePrice]? {
        guard let averagePrices = averagePrices,
            defaultBPICurrency.rate > 0.0 else {
            return nil
        }
                
        return averagePrices.map { CoinAveragePrice(price: newBpiCurrency.rate * ($0.price / defaultBPICurrency.rate), dateFrom: $0.dateFrom, dateTo: $0.dateTo) }
    }
    
}
