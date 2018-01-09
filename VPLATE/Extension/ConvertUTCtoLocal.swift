//
//  ConvertUTCtoLocal.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 9..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation



extension String {
    func convertStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: self) else {return ""}
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let result = dateFormatter.string(from: date)
        return result
    }
}
