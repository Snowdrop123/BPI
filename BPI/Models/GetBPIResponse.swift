//
//  GetBPIResponse.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct GetBPIResponse: Decodable {
    var bpi: [String: Double]
}
