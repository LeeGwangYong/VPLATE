//
//  RandomColor.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
