//
//  InsertImageToString.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//
import UIKit


extension UIImage {
    func addImage() -> String
    {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = self
        
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
    
        return myString.string
    }
}
