//
//  ComunityViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MMPlayerView

class CommunityViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var myVideoBtn: UIButton!
    let alphaValue: CGFloat = 0.9
    
    let data = ["https://hyunho9304.s3.ap-northeast-2.amazonaws.com/1515402618128.mp4"]
    
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let layer = MMPlayerLayer()
        layer.cacheType = .memory(count: 5)
        layer.coverFitType = .fitToPlayerView
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.replace(cover: CoverA.instantiateFromNib())
        return layer
    }()
    
    var tableViewIndex: Int?
    //var queue: DispatchQueue?

    func setStatusBarDark(dark: Bool){
        let color: UIColor = dark ? UIColor.black : UIColor.clear
        let status: UIStatusBarStyle = dark ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
        UIApplication.shared.statusBarStyle = status
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarDark(dark: true)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        self.setButtonAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: alphaValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateByContentOffset()
            self.startLoading()
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarDark(dark: false)
        super.viewWillDisappear(animated)
        self.mmPlayerLayer.player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func navigateAction(_ sender: UIButton) {
        let root = self.presentingViewController as! UITabBarController
        root.selectedIndex = self.tableViewIndex!
        //{self.mmPlayerLayer.currentPlayStatus = .unknown}
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rankingAction(_ sender: UIButton) {
    }
    @IBAction func myVideoAction(_ sender: UIButton) {
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(startLoading), with: nil, afterDelay: 0.2)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func updateByContentOffset() {
        let index = self.videoCollectionView.detectCurrentCellIndexPath()
        print("Current : \(videoCollectionView.contentOffset)")
        if let prevCell = self.videoCollectionView.cellForItem(at: IndexPath(row: index.row - 1, section: 0) ) {
            
            UIView.animate(withDuration: 2, animations: {
                prevCell.contentView.alpha = 0.3
            })
        }
        if let nextCell = self.videoCollectionView.cellForItem(at: IndexPath(row: index.row + 1, section: 0) ) {
            
            UIView.animate(withDuration: 0.5, animations: {
                nextCell.contentView.alpha = 0.3
            })
        }
        
        if let currentCell = self.videoCollectionView.cellForItem(at: index) as? CommunityVideoCollectionViewCell{
            UIView.animate(withDuration: 0.5, animations: {
                currentCell.contentView.alpha = 1.0
            })
            
            mmPlayerLayer.thumbImageView.image = currentCell.imgView.image
            if !MMLandscapeWindow.shared.isKeyWindow {
                mmPlayerLayer.playView = currentCell.imgView
            }
            
            mmPlayerLayer.set(url: currentCell.data?.play_Url, state: { (status) in
                switch status {
                case .failed(let err):
                    let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .ready:
                    print("Ready to Play")
                case .playing:
                    print("Playing")
                case .pause:
                    print("Pause")
                case .end:
                    print("End")
                default: break
                }
            })
        }
    }
    @objc func startLoading() {
        mmPlayerLayer.startLoading()
        
    }
}



extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = videoCollectionView.bounds.width
        let itemHeight = videoCollectionView.bounds.height * 0.7
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(videoCollectionView.bounds.height * 0.15,0,videoCollectionView.bounds.height * 0.15,0); // top, left, bottom, right
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.4) {
            self.setButtonAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: 0)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.4) {
            self.setButtonAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: self.alphaValue)
        }
    }
    
    func setButtonAlpah(buttons: [UIButton], value: CGFloat){
        for item in buttons {
            item.alpha = value
        }
    }
}


extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityVideoCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityVideoCollectionViewCell
        let url = URL(string: data[indexPath.row])
        cell.data = DataObj(image: getThumbnailImage(forUrl: url!), play_Url: url, title: "title", content: "content")
        cell.imgView.backgroundColor = UIColor().random()
        return cell
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


