//
//  BPICurrency.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct BPICurrency {
    
    var code: String
//    var symbol: String
    var formattedRate: String
    var rate: Double
    
    init?(dictionary: [String: Any?]) {
        guard let code = dictionary["code"] as? String,
//            let symbol = dictionary["symbol"] as? String,
            let formattedRate = dictionary["rate"] as? String,
            let rate = dictionary["rate_float"] as? Double else {
                return nil
        }
        
        self.code = code
//        self.symbol = symbol
        self.formattedRate = formattedRate
        self.rate = rate
        
    }
    
}
