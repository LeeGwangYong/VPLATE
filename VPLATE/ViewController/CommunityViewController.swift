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
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let layer = MMPlayerLayer()
        layer.cacheType = .memory(count: 5)
        layer.coverFitType = .fitToPlayerView
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.replace(cover: CoverA.instantiateFromNib())
        return layer
    }()
    
    var tableViewIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.isPagingEnabled = false
        videoCollectionView.showsVerticalScrollIndicator = false
        videoCollectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.updateByContentOffset()
        }
    }
    
    @IBAction func navigateAction(_ sender: UIButton) {
        let root = self.presentingViewController as! UITabBarController
        root.selectedIndex = self.tableViewIndex!
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(startLoading), with: nil, afterDelay: 0.3)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func updateByContentOffset() {
        self.updateCell(at: self.videoCollectionView.detectCurrentCellIndexPath())
    }
    @objc func startLoading() {
        mmPlayerLayer.startLoading()
    }
    
    func updateCell(at indexPath: IndexPath){
        guard let cell = videoCollectionView.currentCell() as? CommunityVideoCollectionViewCell else {return}
        mmPlayerLayer.thumbImageView.image = cell.imgView.image
        if !MMLandscapeWindow.shared.isKeyWindow {
            mmPlayerLayer.playView = cell.imgView
        }
        
        mmPlayerLayer.set(url: cell.data?.play_Url, state: { (status) in
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


