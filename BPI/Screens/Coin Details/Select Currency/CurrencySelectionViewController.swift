//
//  CurrencySelectionViewController.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CurrencySelectionViewController: UIViewController {
    
    private weak var currenciesDataStore: CurrenciesDataStore!
    let request: GetCoinPriceRequest?
    
    private var currentCurrencyName: String {
        currenciesDataStore!.currentCurrencyName
    }
    
    private var currencies: [Currency] {
        currenciesDataStore.currencies
    }
    
    var currencyUpdated: ((BPICurrency) -> ())?
        
    init(currenciesDataStore: CurrenciesDataStore, request: GetCoinPriceRequest) {
        self.currenciesDataStore = currenciesDataStore
        self.request = request
        super.init(nibName: "CurrencySelectionViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var currentCurrencyRatioLabel: UILabel! {
        didSet {
            setCurrencyRatioEmptyText(with: currenciesDataStore.defaultCurrency)
        }
    }
    
    private func setCurrencyRatioEmptyText(with currency: Currency) {
        let defaultText = "1 BTC = - \(currency.rawValue)"
        currentCurrencyRatioLabel.text = defaultText
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        let alertViewController = UIAlertController(title: "Изменить валюту?", message: "Выберите валюту обмена", preferredStyle: .actionSheet)
        currencies.forEach { (currency) in
            let alertAction = UIAlertAction(title: currency.rawValue, style: .default) { [unowned self] (action) in
                self.select(currency: currency)
            }
            alertViewController.addAction(alertAction)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)

        present(alertViewController, animated: true, completion: nil)
    }
    
    public func updateView(with currency: BPICurrency?) {
        guard let currency = currency else {
            setCurrencyRatioEmptyText(with: currenciesDataStore.defaultCurrency)
            return
        }
        print("currency.code, ", currency.code)
        currentCurrencyRatioLabel.text = "1 BTC = \(currency.rate) \(currency.code)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBPICurrency(for: currenciesDataStore.defaultCurrency)
    }
    
    private func getBPICurrency(for currency: Currency) {
        
        _ = request?.getCoinPrice(currency: currency) { [weak self] (result) in
            switch result {
            case .success(let currency):
                self?.currencyUpdated?(currency)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func select(currency: Currency) {
        setCurrencyRatioEmptyText(with: currency)
        getBPICurrency(for: currency)
    }
    
}
