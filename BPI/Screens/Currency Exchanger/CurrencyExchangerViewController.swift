//
//  CurrencyExchangerViewController.swift
//  BPI
//
//  Created by Admin on 6/24/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CurrencyExchangerViewController: UIViewController {
    
    private weak var currenciesDataStore: CurrenciesDataStore!
    
    private var currentCurrencyName: String {
        currenciesDataStore!.currentCurrencyName
    }
    
    private var currencies: [Currency] {
        currenciesDataStore.currencies
    }
    
    let getCoinPriceRequest: GetCoinPriceRequest?
    
    init(currenciesDataStore: CurrenciesDataStore, getCoinPriceRequest: GetCoinPriceRequest) {
        self.currenciesDataStore = currenciesDataStore
        self.getCoinPriceRequest = getCoinPriceRequest
        super.init(nibName: "CurrencyExchangerViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private weak var currencyAmountTextField: UITextField! {
        didSet {
            let bar = UIToolbar()
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelKeyboard))
            bar.items = [cancel]
            bar.sizeToFit()
            currencyAmountTextField.inputAccessoryView = bar
        }
    }
    
    @IBOutlet weak var calculateButton: UIButton!
    @objc private func cancelKeyboard() {
        currencyAmountTextField.resignFirstResponder()
    }
    
    @IBOutlet weak var selectCurrencyButton: UIButton!
    @IBOutlet weak var coinsAmountLabel: UILabel!
    
    @IBAction func selectCurrency(_ sender: UIButton) {
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
    
    lazy var selectedCurrency: Currency = {
        return currenciesDataStore.defaultCurrency
    }()
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard let inputPrice = inputPrice else {
            return
        }
        
        _ = getCoinPriceRequest?.getCoinPrice(currency: selectedCurrency, completion: { [weak self] (result) in
            
            guard let `self` = self else {
                return
            }
            switch result {
            case .success(let bpiCurrency):
                let coinsAmount = Double(inputPrice) / bpiCurrency.rate
                self.coinsAmountLabel.text = "\(inputPrice) \(self.selectedCurrency.rawValue) = \(coinsAmount) BTC"
            case .failure(let error):
                print("error, ", error.localizedDescription)
                break
            }
        })
    }
    
    private var inputPrice: Int? {
        if let text = currencyAmountTextField.text,
            let price = Int(text) {
            return price
        } else {
            return nil
        }
    }
    
    private func select(currency: Currency) {
        selectedCurrency = currency
        selectCurrencyButton.setTitle(currency.rawValue, for: .normal)

        if let inputPrice = inputPrice {
            currencyAmountTextField.text = "\(inputPrice)"
        }
    }
    
}
