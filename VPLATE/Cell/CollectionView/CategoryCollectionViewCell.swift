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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
//    var info: Info? {
//        didSet{
//            
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    func reload() {
        if isSelected {
            backgroundImageView.backgroundColor = UIColor.black
        } else {
            backgroundImageView.backgroundColor = UIColor().random()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
