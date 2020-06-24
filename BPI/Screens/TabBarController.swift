//
//  TabBarController.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, CurrenciesDataStore, BPICurrencyDataStore {
    
    var currencies: [Currency] = [.USD, .EUR, .KZT]
    let defaultCurrency: Currency = .USD
    var currentCurrencyName: String {
        return bpiCurrency?.code ?? currencies[0].rawValue
    }
    
    var defaultBPICurrency: BPICurrency?
    var bpiCurrency: BPICurrency?
    
    lazy var coinDetailsViewController: CoinDetailsViewController = {
        let coinDetailsVCBuilder = CoinDetailsVCBuilder(currenciesDataStore: self)
        let coinDetailsViewController = coinDetailsVCBuilder.buildCoinDetailsVC()
        return coinDetailsViewController
    }()
    
    lazy var transactionListViewController: TransactionsListViewController = TransactionsListViewController(transactionsDataSource: TransactionsDataProvider(getTransactionsRequest: RemoteGetTransactionsRequest()))
        
    lazy var currencyExchangerViewController = CurrencyExchangerViewController(currenciesDataStore: self, getCoinPriceRequest: RemoteGetCoinPriceRequest())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coinDetailsNavigationController = UINavigationController(rootViewController: coinDetailsViewController)
        coinDetailsViewController.title = "Курс"
        coinDetailsNavigationController.tabBarItem = UITabBarItem(title: "Курс", image: nil, selectedImage: nil)
        
        let transactionListNavigationController = UINavigationController(rootViewController: transactionListViewController)
        transactionListViewController.title = "Транзакции"
        transactionListViewController.tabBarItem = UITabBarItem(title: "Транзакции", image: nil, selectedImage: nil)

        let currencyExchangerNavigationController = UINavigationController(rootViewController: currencyExchangerViewController)
        currencyExchangerViewController.title = "Конвертация"
        currencyExchangerViewController.tabBarItem = UITabBarItem(title: "Конвертация", image: nil, selectedImage: nil)

        viewControllers = [coinDetailsNavigationController, transactionListNavigationController, currencyExchangerNavigationController]
    }
    
}
