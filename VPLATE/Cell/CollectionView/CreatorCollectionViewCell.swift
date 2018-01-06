//
//  CreatorCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CreatorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sceneView: UIView!
    
    @IBOutlet weak var sceneNumLabel: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.isEnabled = false
    }

}
