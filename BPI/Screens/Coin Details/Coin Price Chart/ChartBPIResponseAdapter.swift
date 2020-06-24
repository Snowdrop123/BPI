//
//  ChartBPIResponseAdapter.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct ChartBPIResponseAdapter {
    
    struct TempStorage {
        var price: Double
        var date: Date
    }
    
    private var getBPIResponse: GetBPIResponse
    
    init(getBPIResponse: GetBPIResponse) {
        self.getBPIResponse = getBPIResponse
    }
    
    public func getViewModel(for chartDateType: ChartDateType) -> CoinPriceChartViewModel {
        let averagePrices = convertToAveragePrices(for: chartDateType)
        let viewModel = CoinPriceChartViewModel(averagePrices: averagePrices)
        return viewModel
    }
    
    private func convertToAveragePrices(for chartDateType: ChartDateType) -> [CoinAveragePrice] {
        //terrible algorithm :)

        let tempStorage = getApiDataInSortedByDateContainer()
        
        let daysToCut = getDaysToCut(for: chartDateType)
        var currentDays: Int = 0
        var tempStorage2: [TempStorage] = []
        var result: [CoinAveragePrice] = []
        
        for i in tempStorage.indices {
            currentDays += 1
            tempStorage2.append(tempStorage[i])
            if daysToCut == currentDays {
                currentDays = 0

                guard let firstDate = tempStorage2.first?.date,
                let lastDate = tempStorage2.last?.date else {
                    continue
                }
                                
                let totalTempPrices = tempStorage2.map { $0.price }.reduce(0, +)
                let averagePrice = totalTempPrices/Double(tempStorage2.count)
                let currentAveragePrice = CoinAveragePrice(price: averagePrice, dateFrom: firstDate, dateTo: lastDate)
                print("firstDate, ", firstDate)
                print("lastDate, ", lastDate)
                result.append(currentAveragePrice)
                tempStorage2 = []
            }
        }
        return result
    }
    
    private func getApiDataInSortedByDateContainer() -> [TempStorage] {
        var tempStorage: [TempStorage] = []
        let sortedBPIValues = getBPIResponse.bpi.sorted(by: <)
        for (key, value) in sortedBPIValues {
            guard let date = key.mainDateFormatDate() else {
                continue
            }
            let temp = TempStorage(price: value, date: date)
            tempStorage.append(temp)
        }
        return tempStorage
    }
    
    private func getDaysToCut(for chartDateType: ChartDateType) -> Int {
        switch chartDateType {
        case .week:
            return 1
        case .month:
            return 7
        case .year:
            return 30
        }
    }
    
}
