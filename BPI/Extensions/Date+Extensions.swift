//
//  Date+Extensions.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension Date {
    public func mainDateFormatString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.mainDateFormat
        return dateformatter.string(from: self)
    }
}
