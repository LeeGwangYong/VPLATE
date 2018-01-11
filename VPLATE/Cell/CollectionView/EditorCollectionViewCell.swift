//
//  EditorCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class EditorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(printTap)) )
        //profileImageButton.addTarget(self, selector: #selector(userPhotoTaped), action: .touchUpInside)

    }
    @objc func printTap() {
        print("Image Tap")
    }

}
