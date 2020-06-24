//
//  RemoteGetBPIRequest.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RemoteGetBPIRequest: GetBPIRequest {
    func getBPI(chartDateType: ChartDateType, completion: @escaping (Result<GetBPIResponse, Error>) -> ()) -> URLSessionDataTask? {
        
        let url = "https://api.coindesk.com/v1/bpi/historical/close.json"
        
        guard let queryItems = chartDateType.queryItems else {
            completion(.failure(APIErrors.apiError(0, "Что-то не так с датами")))
            return nil
        }
        
        let task = API.sharedInstance.getModelRequest(method: .get, url: url, queryItems: queryItems, timeout: nil, headers: nil, parameters: nil, objectType: GetBPIResponse.self) { (result) in
            
            switch result {
            case.success(let response):
                completion(.success(response))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
        
        return task
    }
    
    
}

fileprivate extension ChartDateType {
    var queryItems: [String: String?]? {
        guard let startDate = startDateFromCurrentDate else {
            return nil
        }
        let endDate = Date()
        return ["start": startDate.mainDateFormatString(), "end": endDate.mainDateFormatString()]
    }
    
    var startDateFromCurrentDate: Date? {
        get {
            switch self {
            case .week: return Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())
            case .month: return Calendar.current.date(byAdding: .month, value: -1, to: Date())
            case .year: return Calendar.current.date(byAdding: .year, value: -1, to: Date())
            }
        }
        
    }
}
