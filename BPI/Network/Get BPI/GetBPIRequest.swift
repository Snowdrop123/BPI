//
//  GetBPIRequest.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol GetBPIRequest {
    func getBPI(chartDateType: ChartDateType, completion: @escaping (Result<GetBPIResponse, Error>) -> ()) -> URLSessionDataTask?
}
