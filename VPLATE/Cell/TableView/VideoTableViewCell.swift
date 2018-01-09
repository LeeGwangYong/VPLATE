//
//  VideoTableViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import Kingfisher
class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var info: Template? {
        didSet{
            categoryLabel.text = info?.template_type
            dateLabel.text = info?.template_uploadtime.convertStringDate()
            titleLabel.text = info?.template_title
            contentLabel.text = info?.template_hashtag
            timeLabel.text = info?.template_length.IntToMMSS()
            
            if let url = info?.template_thumbnail {
                self.thumbnail.kf.setImage(with: URL(string: url))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
