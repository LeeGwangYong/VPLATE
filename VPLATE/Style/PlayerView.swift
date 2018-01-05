//
//  PlayerView.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 4..
//  Copyright © 2018년 이광용. All rights reserved.
//


//  Created by John Xiong on 3/14/17.
//  Copyright © 2017 Xiong. All rights reserved.
//
import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
