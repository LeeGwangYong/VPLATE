//
//  EditorTextCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 13..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class EditorTextCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var constraintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.setBottomBorder()
        // Initialization code
    }
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
