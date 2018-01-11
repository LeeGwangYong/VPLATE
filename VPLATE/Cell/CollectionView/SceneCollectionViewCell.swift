//
//  SceneCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

struct SceneInform {
    let url: String
    let sceneNum: Int
}

class SceneCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var triangleImageView: UIImageView!
    
    var info: SceneInform? {
        didSet{
            if let sceneNum = info?.sceneNum {
                numberLabel.text = "#\(String(format: "%02d", sceneNum))"
            }
            if let urlStr = info?.url {
                if let url = URL(string: urlStr){
                    self.imageView.kf.setImage(with: url)
                }
            }
        }
    }
    
    func reload() {
        if self.isSelected {
            //self.blackView.alpha = 0
            self.triangleImageView.isHidden = false
        }
        else {
            //self.blackView.alpha = 0.6
            self.triangleImageView.isHidden = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.lightGray.cgColor
        self.imageView.kf.indicatorType = .activity
        self.triangleImageView.isHidden = true
        self.blackView.alpha = 0.6
    }
    
}
