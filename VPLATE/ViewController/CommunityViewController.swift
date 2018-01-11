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
import SwiftyJSON

class CommunityViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var myVideoBtn: UIButton!
    @IBOutlet weak var nonImageView: UIImageView!
    let alphaValue: CGFloat = 0.9
    
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let layer = MMPlayerLayer()
        layer.cacheType = .memory(count: 30)
        layer.coverFitType = .fitToPlayerView
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.replace(cover: CoverA.instantiateFromNib())
        return layer
    }()
    var communityVideoList: [CommunityVideo] = []
    var tableViewIndex: Int!

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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCollectionView.removeObserver(self, forKeyPath: "contentOffset")   
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView(collectionView: videoCollectionView, cell: CommunityVideoCollectionViewCell.self)
        videoCollectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        self.setButtonAlpah(buttons: [self.rankingBtn, self.myVideoBtn], value: alphaValue)
        
        self.fetchCommunityVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateByContentOffset()
            self.startLoading()
        }

    }
    
    func fetchCommunityVideo(){
        CommunityListServiece.getList(url: "community/list/latest", parameter: nil, header: Token.getToken()) { (response) in
            switch response {
            case .Success(let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                let community = dataJSON["data"]["community"].map({$0.1})
                let decoder = JSONDecoder()
                do {
                    self.communityVideoList = try community.map({ (jsonData) -> CommunityVideo in
                        let value = try decoder.decode(CommunityVideo.self, from: jsonData.rawData())
                        return value
                    })
                    self.videoCollectionView.reloadData()
                }
                catch (let err) {
                    print(err.localizedDescription)
                }
            case .Failure( _):
                break
            }
        }
    }

    
    
    @IBAction func navigateAction(_ sender: UIButton) {
        guard let root = self.presentingViewController as? TabBarController else { return }
        root.selectedIndex = self.tableViewIndex
        self.dismiss(animated: true, completion: {
            self.mmPlayerLayer.player = nil})
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
        //print("Current : \(videoCollectionView.contentOffset)")
        if let prevCell = self.videoCollectionView.cellForItem(at: IndexPath(row: index.row - 1, section: 0) ) {
            
            UIView.animate(withDuration: 1, animations: {
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
            if let url = URL(string: communityVideoList[index.row].uploadvideo) {
                mmPlayerLayer.set(url: url, state: { (status) in
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
        UIView.animate(withDuration: 1) {
            if self.communityVideoList.count == 0 {
                self.nonImageView.alpha = 1
            }
            else { self.nonImageView.alpha = 0}
        }
        return communityVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityVideoCollectionViewCell.reuseIdentifier, for: indexPath) as! CommunityVideoCollectionViewCell
        cell.info = communityVideoList[indexPath.row]
        return cell
    }
    
}


