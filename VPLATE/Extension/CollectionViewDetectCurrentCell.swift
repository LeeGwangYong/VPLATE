//
//  TableExtension.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit


extension UICollectionView {
    func detectCurrentCell() -> IndexPath {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = self.indexPathForItem(at: visiblePoint)!
        return visibleIndexPath
    }
}


