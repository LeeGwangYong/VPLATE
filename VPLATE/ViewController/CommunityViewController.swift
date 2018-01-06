//
//  ComunityViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit

class CommunityViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    var tableViewIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.isPagingEnabled = false
        videoCollectionView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func navigateAction(_ sender: UIButton) {
        let root = self.presentingViewController as! UITabBarController
        root.selectedIndex = self.tableViewIndex!
        self.dismiss(animated: true, completion: nil)
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
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityVideoCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityVideoCollectionViewCell
        
        cell.setUpPlayer(url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        cell.playerView.backgroundColor = UIColor().random()
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = videoCollectionView.contentOffset
        visibleRect.size = videoCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = videoCollectionView.indexPathForItem(at: visiblePoint)!
        
        print("Will Begin : \(visibleIndexPath)")
        
        (videoCollectionView.cellForItem(at: visibleIndexPath) as! CommunityVideoCollectionViewCell).player?.pause()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = videoCollectionView.contentOffset
        visibleRect.size = videoCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = videoCollectionView.indexPathForItem(at: visiblePoint)!
        
        print("Did End : \(visibleIndexPath)")

        (videoCollectionView.cellForItem(at: visibleIndexPath) as! CommunityVideoCollectionViewCell).player?.play()
    }
}

extension UICollectionView {
    func detectCurrentCell() -> IndexPath {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = self.indexPathForItem(at: visiblePoint)!
        return visibleIndexPath
    }
}

