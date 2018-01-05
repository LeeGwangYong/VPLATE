//
//  ComunityViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVKit

class PagedCollectionLayout : UICollectionViewFlowLayout {
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if velocity.y == 0 {
            return mostRecentOffset
        }
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfHeight = cvBounds.size.height * 0.5;
            
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if (attributes.center.y == 0) || (attributes.center.y > (cv.contentOffset.y + halfHeight) && velocity.y < 0) {
                        continue
                    }
                    candidateAttributes = attributes
                }
                
                // Beautification step , I don't know why it works!
                if(proposedContentOffset.y == -(cv.contentInset.top)) {
                    return proposedContentOffset
                }
                
                guard let _ = candidateAttributes else {
                    return mostRecentOffset
                }
                mostRecentOffset = CGPoint(x: proposedContentOffset.x, y:
                candidateAttributes!.center.y - halfHeight)
                return mostRecentOffset
                
            }
        }
        
        // fallback
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }
}

class CommunityViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    var tableViewIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.isPagingEnabled = false
        videoCollectionView.showsVerticalScrollIndicator = false
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        var insets = self.videoCollectionView.contentInset
//        let value = (self.view.frame.size.height - (self.videoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height) * CGFloat(0.5)
//
//        insets.top = value
//        insets.right = value
//
//        self.videoCollectionView.contentInset = insets
//        self.videoCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
//
//    }
    
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in videoCollectionView.visibleCells as! [CommunityVideoCollectionViewCell] {
            let indexPath = videoCollectionView.indexPath(for: cell as CommunityVideoCollectionViewCell)
            print(indexPath)
        }
    }
}


extension CommunityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityVideoCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityVideoCollectionViewCell
        
        cell.setUpPlayer(url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        cell.playerView.backgroundColor = UIColor(displayP3Red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        
        return cell
    }
    
}

extension CommunityViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let videoCell = cell as! CommunityVideoCollectionViewCell
//        videoCell.player?.play()
//        
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let videoCell = cell as! CommunityVideoCollectionViewCell
//        videoCell.player?.pause()
//    }

}

