//
//  CoinPriceChartDataSource.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

final class CoinPriceChartDataSource {
    
    var request: GetBPIRequest
    var task: URLSessionDataTask?
    
    var cacheImprovisation: [ChartDateType: CoinPriceChartViewModel] = [:]
    
    init(request: GetBPIRequest) {
        self.request = request
    }
    
    func getAveragePrices(for chartDateType: ChartDateType, completion: @escaping (Result<CoinPriceChartViewModel, Error>) -> ()) {
        task?.cancel()
        
        if let viewModel = cacheImprovisation[chartDateType] {
            completion(.success(viewModel))
            return
        }
        
        task = request.getBPI(chartDateType: chartDateType) { [weak self] (result) in
            switch result {
            case.success(let response):
                let adapter = ChartBPIResponseAdapter(getBPIResponse: response)
                let viewModel = adapter.getViewModel(for: chartDateType)
                completion(.success(viewModel))
                self?.cacheImprovisation[chartDateType] = viewModel
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
