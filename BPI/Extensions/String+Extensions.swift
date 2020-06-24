//
//  String+Extensions.swift
//  BPI
//
//  Created by Admin on 6/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension String {
    public func mainDateFormatDate() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = Constants.mainDateFormat
        return dateformatter.date(from: self)

    }
}
