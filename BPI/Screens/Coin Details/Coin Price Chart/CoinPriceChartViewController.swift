//
//  CoinPriceChartViewController.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CoinPriceChartViewController: UIViewController {
        
    private var viewModel: CoinPriceChartViewModel = CoinPriceChartViewModel() {
        didSet {
            graphCollectionView.reloadData()
            graphPricesCollectionView.reloadData()
        }
    }
    private var dataSource: CoinPriceChartDataSource
    private weak var currenciesDataStore: CurrenciesDataStore!
    
    init(dataSource: CoinPriceChartDataSource, currenciesDataStore: CurrenciesDataStore) {
        self.dataSource = dataSource
        self.currenciesDataStore = currenciesDataStore
        super.init(nibName: "CoinPriceChartViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var graphCollectionView: UICollectionView!
    @IBOutlet weak var graphPricesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        graphCollectionView.delegate = self
        graphCollectionView.dataSource = self
        graphCollectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.reuseIdentifier)
        
        graphPricesCollectionView.delegate = self
        graphPricesCollectionView.dataSource = self
        graphPricesCollectionView.register(ChartPricesCollectionViewCell.self, forCellWithReuseIdentifier: ChartPricesCollectionViewCell.reuseIdentifier)
    }
    
    public func getGraphData(for chartDateType: ChartDateType = .week) {
        viewModel = CoinPriceChartViewModel()
        dataSource.getAveragePrices(for: chartDateType) { [weak self] (result) in
            switch result {
            case .success(let viewModel):
                self?.viewModel = viewModel
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    public func updateGraphPrice(defaultBPICurrency: BPICurrency, newBpiCurrency: BPICurrency) {
        viewModel.bpiCurrencyItems = (defaultBPICurrency, newBpiCurrency)
        graphPricesCollectionView.reloadData()
    }
    
}

extension CoinPriceChartViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard collectionView === graphCollectionView else {
            return 1
        }
        
        return viewModel.numberOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView === graphCollectionView else {
            return viewModel.numberOfColumns
        }

        return viewModel.maxPricePercentageRate
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard collectionView === graphCollectionView else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartPricesCollectionViewCell.reuseIdentifier, for: indexPath) as! ChartPricesCollectionViewCell
            if let item = viewModel.item(at: indexPath) {
                cell.setup(with: item)
            }
            
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.reuseIdentifier, for: indexPath)
        
        cell.contentView.backgroundColor = (viewModel.shouldFillCell(at: indexPath)) ? .lightGray : .red
        
        return cell
    }
            
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard collectionView === graphCollectionView,
            viewModel.numberOfColumns > 0 else {
            let itemWidth = collectionView.bounds.width / CGFloat(viewModel.numberOfColumns)
            return CGSize(width: itemWidth, height: collectionView.bounds.height)
        }
        guard viewModel.numberOfColumns > 0, viewModel.maxPricePercentageRate > 0 else {
            return CGSize.zero
        }

        let itemWidth = collectionView.bounds.width / CGFloat(viewModel.numberOfColumns)
        let itemHeight = collectionView.bounds.height / CGFloat(viewModel.maxPricePercentageRate)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
