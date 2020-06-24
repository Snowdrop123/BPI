//
//  RemoteGetTransactionsRequest.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RemoteGetTransactionsRequest: GetTransactionsRequest {
    func getTransactions(completion: @escaping (Result<[GetTransactionsResponse], Error>) -> ()) {
        let url = "https://www.bitstamp.net/api/v2/transactions/btcusd/"
        
//        let queryItems: [String: String?] = ["time": "minute"]
        let queryItems: [String: String?] = ["time": "hour"]

        _ = API.sharedInstance.getModelRequest(method: .get, url: url, queryItems: queryItems, timeout: nil, headers: nil, parameters: nil, objectType: [GetTransactionsResponse].self) { (result) in
            
            switch result {
            case.success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
        
    }    
}
