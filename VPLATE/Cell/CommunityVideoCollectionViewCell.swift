//
//  CommunityVideoCollectionViewCell.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 4..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit

class CommunityVideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerView: UIView!
    
    var player: AVPlayer?
    
    func setUpPlayer(url: String) {
        guard let videoURL = URL(string: url) else {return}
        self.player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = (self.bounds)
        self.playerView.layer.addSublayer(playerLayer)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
