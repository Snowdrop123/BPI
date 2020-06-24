//
//  RemoteGetCoinPriceRequest.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RemoteGetCoinPriceRequest: GetCoinPriceRequest {
    
    func getCoinPrice(currency: Currency, completion: @escaping (Result<BPICurrency, Error>) -> ()) -> URLSessionDataTask? {
        
        let backendFormattedCurrencyName = currency.backendName
        let url = "https://api.coindesk.com/v1/bpi/currentprice/\(backendFormattedCurrencyName).json"

        let task = API.sharedInstance.getDictionaryRequest(method: .get, url: url, queryItems: nil, timeout: nil, headers: nil, parameters: nil) { (result) in
            
            switch result {
            case.success(let response):
                if let bpi = response["bpi"] as? [String: Any?],
                    let currencyDictionary = bpi[backendFormattedCurrencyName] as? [String: Any?],
                    let currency = BPICurrency(dictionary: currencyDictionary) {
                    completion(.success(currency))
                } else {
                    completion(.failure(APIErrors.apiError(0, "Ошибка при mapping currency")))
                }
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
        
        return task
    }
    
}

fileprivate extension Currency {
    var backendName: String {
        switch self {
        case .USD: return "USD"
        case .KZT: return "KZT"
        case .EUR: return "EUR"
        }
    }
}
