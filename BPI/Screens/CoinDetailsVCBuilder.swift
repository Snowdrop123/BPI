//
//  CoinDetailsVCBuilder.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol CurrenciesDataStore: class {
    var currencies: [Currency] { get }
    var currentCurrencyName: String { get }
    var defaultCurrency: Currency { get }
}

protocol BPICurrencyDataStore {
    var defaultBPICurrency: BPICurrency? { get set }
    var bpiCurrency: BPICurrency? { get set }
}

class CoinDetailsVCBuilder {
    
    weak var currenciesDataStore: (CurrenciesDataStore & BPICurrencyDataStore)!
    
    init(currenciesDataStore: CurrenciesDataStore & BPICurrencyDataStore) {
        self.currenciesDataStore = currenciesDataStore
    }
    
    func buildCoinDetailsVC() -> CoinDetailsViewController {
        let currencySelectionViewController = buildCurrencySelectionVC()
        let coinPriceChartViewController = buildCoinPriceChartVC()
        let coinDetailsViewController = CoinDetailsViewController(currenciesAndBPIDataStore: currenciesDataStore, currencySelectionViewController: currencySelectionViewController, coinPriceChartViewController: coinPriceChartViewController)
        return coinDetailsViewController
    }
    
    func buildCurrencySelectionVC() -> CurrencySelectionViewController {
        let currencySelectionViewController = CurrencySelectionViewController(currenciesDataStore: currenciesDataStore, request: RemoteGetCoinPriceRequest())
        return currencySelectionViewController
    }
    
    func buildCoinPriceChartVC() -> CoinPriceChartViewController {
        let dataStore = CoinPriceChartDataSource(request: RemoteGetBPIRequest())
        let coinPriceChartViewController = CoinPriceChartViewController(dataSource: dataStore, currenciesDataStore: currenciesDataStore)
        return coinPriceChartViewController
    }
    
}
