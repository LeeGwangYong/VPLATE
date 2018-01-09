//
//  IntToMMSS.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 9..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

extension Int {
    func IntToMMSS() -> String{
        let m = String(format: "%02d", self % 3600 / 60)
        return "\(m):\((self % 3600) % 60)"
    }
}
