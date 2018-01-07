//
//  ComunityViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit
import MMPlayerView

class CommunityViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var myVideoBtn: UIButton!
    let alphaValue: CGFloat = 0.8
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        self.setButtnAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: alphaValue)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.updateByContentOffset()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        if let prevCell = self.videoCollectionView.cellForItem(at: IndexPath(row: index.row - 1, section: 0) ) {
            
            UIView.animate(withDuration: 2, animations: {
              //  prevCell.layoutIfNeeded()
                prevCell.contentView.alpha = 0.3
            })
        }
        if let nextCell = self.videoCollectionView.cellForItem(at: IndexPath(row: index.row + 1, section: 0) ) {
            
            UIView.animate(withDuration: 0.5, animations: {
            //    nextCell.layoutIfNeeded()
                nextCell.contentView.alpha = 0.3
            })
        }
        
        if let currentCell = self.videoCollectionView.cellForItem(at: index) as? CommunityVideoCollectionViewCell{
            UIView.animate(withDuration: 0.5, animations: {
                currentCell.contentView.alpha = 1.0
            })
            //currentCell.contentView.alpha = 1.0
            
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
            self.setButtnAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: 0)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.4) {
            self.setButtnAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: self.alphaValue)
        }
    }
    
    func setButtnAlpah(buttons: [UIButton], value: CGFloat){
        for item in buttons {
            item.alpha = value
        }
    }
}


extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DemoSource.shared.demoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityVideoCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityVideoCollectionViewCell
        
        cell.data = DemoSource.shared.demoData[indexPath.row]
        cell.imgView.backgroundColor = UIColor().random()
        return cell
    }
}


