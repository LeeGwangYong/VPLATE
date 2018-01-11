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
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var info: CommunityVideo?{
        didSet{
            //self.imgView.image = data?.image
            if let profileString = info?.profile, let url = URL(string: profileString){
                self.profileImage.kf.setImage(with: url)
            }
            self.dateLabel.text = info?.uploadtime.convertStringDate()
            self.nameLabel.text = info?.nickname
            if let hits = info?.hits {
                self.likeButton.setTitle("\(hits)", for: .normal)
            }
            self.contentLabel.text = info?.content
            if let videoString = info?.uploadvideo, let url = URL(string: videoString) {
                self.imgView.image = getThumbnailImage(forUrl: url)
            }
        }
    }
    var player: AVPlayer?
    
    func setUpPlayer(url: String) {
        guard let videoURL = URL(string: url) else {return}
        self.player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = (self.bounds)
        self.imgView.layer.addSublayer(playerLayer)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }

}
