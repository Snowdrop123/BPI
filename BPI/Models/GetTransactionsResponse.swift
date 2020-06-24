//
//  GetTransactionsResponse.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct GetTransactionsResponse: Decodable {
    var date: String
    var tid: String
    var price: String
    var type: String
    var amount: String
}
