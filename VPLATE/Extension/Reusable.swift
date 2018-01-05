//
//  Reusable.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation

extension NSObject{
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}
