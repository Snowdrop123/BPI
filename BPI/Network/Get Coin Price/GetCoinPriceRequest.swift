//
//  GetCoinPriceRequest.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol GetCoinPriceRequest {
    func getCoinPrice(currency: Currency, completion: @escaping (Result<BPICurrency, Error>) -> ()) -> URLSessionDataTask?
}
