//
//  CategoryCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    func reload() {
        if isSelected {
            selectedImageView.alpha = 1
        } else {
            selectedImageView.alpha = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
