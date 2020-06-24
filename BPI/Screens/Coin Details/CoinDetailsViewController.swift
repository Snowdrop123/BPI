//
//  CoinDetailsViewController.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

extension UIView {
    func pinEdges(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

class CoinDetailsViewController: UIViewController, BPICurrencyDataStore {
    
    @IBOutlet weak var selectCurrencyView: UIView!
    @IBOutlet weak var graphView: UIView!    
    @IBOutlet weak var selectDateView: UIView!
    
    private weak var currenciesAndBPIDataStore: (CurrenciesDataStore & BPICurrencyDataStore)!
    
    var defaultBPICurrency: BPICurrency? {
        get {
            currenciesAndBPIDataStore.defaultBPICurrency
        }
        set {
            currenciesAndBPIDataStore.defaultBPICurrency = newValue
        }
    }
    
    var bpiCurrency: BPICurrency? = nil {
        didSet {
            guard let bpiCurrency = bpiCurrency else {
                return
            }
            
            if defaultBPICurrency == nil {
                defaultBPICurrency = bpiCurrency
            }
            currenciesAndBPIDataStore.bpiCurrency = bpiCurrency
            chartViewController.updateGraphPrice(defaultBPICurrency: defaultBPICurrency ?? bpiCurrency, newBpiCurrency: bpiCurrency)
            currencySelectionViewController.updateView(with: bpiCurrency)
        }
    }
    
    init(currenciesAndBPIDataStore: CurrenciesDataStore & BPICurrencyDataStore, currencySelectionViewController: CurrencySelectionViewController, coinPriceChartViewController: CoinPriceChartViewController) {
        self.currenciesAndBPIDataStore = currenciesAndBPIDataStore
        self.currencySelectionViewController = currencySelectionViewController
        self.chartViewController = coinPriceChartViewController
        super.init(nibName: "CoinDetailsViewController", bundle: nil)
        currencySelectionViewController.currencyUpdated = { [weak self] (bpiCurrency) in
            self?.bpiCurrency = bpiCurrency
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let currencySelectionViewController: CurrencySelectionViewController
    let chartViewController: CoinPriceChartViewController
    lazy var segmentControlVC: CoinDetailsSegmentControlViewController = {
        let result = CoinDetailsSegmentControlViewController()
        result.selectedTab = { [unowned chartViewController] (dateType) in
            chartViewController.getGraphData(for: dateType)
        }
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
               
        add(segmentControlVC)
        segmentControlVC.view.pinEdges(to: selectDateView)

        add(chartViewController)
        chartViewController.view.pinEdges(to: graphView)

        add(currencySelectionViewController)
        currencySelectionViewController.view.pinEdges(to: selectCurrencyView)
        
        chartViewController.getGraphData()
    }
    
}
