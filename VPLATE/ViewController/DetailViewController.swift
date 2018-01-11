//
//  DetailViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
import MMPlayerView
import AVKit
import Toast_Swift

class DetailViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var playerView: MMPlayerView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var bookMark: UIButton!
    
    var info: Template?
    var id: Int!
    var thumbImage: UIImage = #imageLiteral(resourceName: "16-9-dummy-image6")
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.playerView.player?.pause()
    }
    
    func fetchTemplateInform() {
        TemplateListServiece.getTemplateList(url: "account/template/inform/detail", method: .get, parameter: ["templateid" : id], header: Token.getToken()) { (response) in
            switch response {
            case .Success(let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                if let content = dataJSON["data"]["template_content"] as JSON? {
                    self.contentLabel.text = content.string
                }
                if let bookmarked = dataJSON["data"]["template_bookmarkTemplate"] as JSON? {
                    let img = bookmarked.int == 1 ?  #imageLiteral(resourceName: "favorite_white") : #imageLiteral(resourceName: "favorite_clear")
                    self.bookMark.setImage(img, for: .normal)
                }
                if let videoURL = dataJSON["data"]["template_video"] as JSON?{
                    print("비디오 URL : \(videoURL)")
                    if let url = URL(string: videoURL.string!) {
                        self.playerView.replace(cover: CoverA.instantiateFromNib())
                        self.playerView.set(url: url, thumbImage: self.thumbImage) { (status) in
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
                        }
                    }
                }
                self.playerView.startLoading()
                break
            case .Failure(_):
                break
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchTemplateInform()
        playerView.cacheType = .memory(count: 30)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.title = TitleEnum.detail.rawValue
        
        id = info?.template_id
        categoryLabel.text = info?.template_type
        dateLabel.text = info?.template_uploadtime.convertStringDate()
        titleLabel.text = info?.template_title
        hashLabel.text = info?.template_hashtag
        timeLabel.text = info?.template_length.IntToMMSS()
        
        //bookMark.imageView?.image = info?.template_hits == 1 ?  #imageLiteral(resourceName: "favorite_white") : #imageLiteral(resourceName: "favorite_clear")
        if let thumbnail = info?.template_thumbnail {
            let imgView = UIImageView()
            imgView.kf.setImage(with: URL(string: thumbnail))
            self.thumbImage = imgView.image!
        }
        ratioLabel.text = "16 : 9"
        mediaLabel.text = "(준비 중)"
    }
    
    @IBAction func bookMarkAction(_ sender: Any) {
        TemplateListServiece.getTemplateList(url: "account/template/bookmark", method: .put, parameter: ["templateid" : id], header: Token.getToken()) { (response) in            switch response {
            case .Success(let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                if let bookmark = dataJSON["bookmark"] as JSON? {
                    var img = UIImage()
                    if bookmark.int == 1 {
                        img = #imageLiteral(resourceName: "favorite_white")
                        
                        self.view.makeToast("찜하였습니다", duration: 1.0, position: .center, style: ToastStyle())
                    }
                    else {
                        img = #imageLiteral(resourceName: "favorite_clear")
                        self.view.makeToast("찜을 취소하였습니다", duration: 1.0, position: .center, style: ToastStyle())
                    }
                    self.bookMark.setImage(img, for: .normal)
                }
            case .Failure(_):
                self.view.makeToast("찜 변경이 실패하였습니다", duration: 1.0, position: .center, style: ToastStyle())
                break
            }
        }
    }
    
    @IBAction func navigateCreator(_ sender: UIButton) {
        let vc: CreatorViewController = getNextViewController(viewController: CreatorViewController.self) as! CreatorViewController
        vc.templateID = self.info?.template_id
        vc.thumbnailImage = self.thumbImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
    


