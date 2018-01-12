//
//  CreatorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import PageMenu

class CreatorViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var sceneCollectionView: UICollectionView!
    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var pageMenuView: UIView!
    
    //var editData: EditorDetailData?
    
    struct Editors {
        let template_type: String
        let template_length: Int
        let template_thumbnail: String
        let template_hits: Int
        let template_title: String
        let template_id: Int
        let template_hashtag: String
        let template_uploadtime: String
        let template_content: String?
        let editor_Scenes: [EditorData]?
    }
    
    struct EditorData {
        let sceneNumber: Int
        let clips: [Any]
        let detail: [EditorDetailData]
    }
    
struct EditorDetailData {
        let type: EditorType
        let indexInform: [Int : Double] // length or ratio
    }

    func setData() {
        var editorDetails1: [EditorDetailData] = []
        var editorDetailData1 = EditorDetailData(type: .video, indexInform: [1 : 5, 3: 6])
        editorDetails1.append(editorDetailData1)
        editorDetailData1 = EditorDetailData(type: .picture, indexInform: [2: Double(16/9), 5: Double(9/16)])
        editorDetails1.append(editorDetailData1)
        
        var editorDetails2: [EditorDetailData] = []
        var editorDetailData2 = EditorDetailData(type: .video, indexInform: [6 : 5])
        editorDetails2.append(editorDetailData2)
        editorDetailData2 = EditorDetailData(type: .picture, indexInform: [7: Double(16/9), 10: Double(9/16), 11: Double(4/3)])
        editorDetails2.append(editorDetailData2)
        
        editorDatas.append(EditorData(sceneNumber: 1, clips: [], detail: editorDetails1))
        editorDatas.append(EditorData(sceneNumber: 2, clips: [], detail: editorDetails2))
        editorDatas.append(EditorData(sceneNumber: 3, clips: [], detail: editorDetails1))
        editorDatas.append(EditorData(sceneNumber: 4, clips: [], detail: editorDetails2))
        editorDatas.append(EditorData(sceneNumber: 5, clips: [], detail: editorDetails2))
        editorDatas.append(EditorData(sceneNumber: 6, clips: [], detail: editorDetails1))
        editorDatas.append(EditorData(sceneNumber: 7, clips: [], detail: editorDetails1))
    }
    var editorDatas: [EditorData] = []
    
    
    var thumbnailImage: UIImage!
    var templateID: Int!
    var sceneURL: [String] = []
    
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    
    override func viewDidLoad() {
        setData()
        super.viewDidLoad()
        self.navigationItem.title = TitleEnum.creator.rawValue
        setUpCollectionView(collectionView: sceneCollectionView, cell: SceneCollectionViewCell.self)
        
        cropper.picker = picker
        cropper.delegate = self
        cropper.cropRatio = 16/9
        
        sceneImageView.image = thumbnailImage
        fetchTemplateInform()
        if #available(iOS 10.0, *) {
            sceneCollectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
        
//        self.editData = EditorDetailData(type: .video,
//                                         indexInform: [1 : 5,
//                                                       2 : 2])
        setUpPageMenu(index: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.sceneCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }

    var pageMenu: CAPSPageMenu?
    func setUpPageMenu(index: Int){
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1: EditorViewController = EditorViewController(nibName: EditorViewController.reuseIdentifier, bundle: nil)
        controller1.title = "VIDEO"
        controller1.parentNavigation = self.navigationController
        if self.editorDatas[index].detail[0].type == EditorType.video {
            controller1.editData = self.editorDatas[index].detail[0]
        }
        controllerArray.append(controller1)
        
        let controller2: EditorViewController = EditorViewController(nibName: EditorViewController.reuseIdentifier, bundle: nil)
        controller2.title = "PICTURE"
        controller2.parentNavigation = self.navigationController
        if self.editorDatas[index].detail[1].type == EditorType.picture {
            controller2.editData = self.editorDatas[index].detail[1]
        }
        controllerArray.append(controller2)
        
        
        let font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
        
        let menuHeight:CGFloat = super.view.frame.height * 0.05// 50.0
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.black.withAlphaComponent(0.38) ),
            .menuItemFont(font),
            .menuHeight(menuHeight),
            .menuMargin(0),
            .menuItemWidth(100),
            .selectionIndicatorHeight(0),
            .bottomMenuHairlineColor(UIColor.white),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.black),]
        
        
        // Initialize scroll menu
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                frame: CGRect(x: 0.0, y: 0.0, width: self.pageMenuView.frame.width, height: self.pageMenuView.frame.height),
                                pageMenuOptions: parameters)
        
        for subview in (pageMenu?.view.subviews)! {
            if let scroll = subview as? UIScrollView {
                scroll.isScrollEnabled = false
            }
        }
        self.pageMenuView.addSubview(pageMenu!.view)
    }
    
    func fetchTemplateInform() {
        TemplateListServiece.getTemplateList(url: "account/template/inform/scene/", method: .get, parameter: ["templateid" : templateID], header: Token.getToken()) { (response) in
            switch response {
            case .Success (let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                let urls = dataJSON["data"].arrayValue
                self.sceneURL = urls.map({ (jsonData) -> String in
                    guard let jsonData = jsonData as JSON? else {return ""}
                    guard let url = jsonData.string else {return ""}
                    return url
                }).filter({ (str) -> Bool in
                    return str == "" ? false : true
                })
                
                self.sceneCollectionView.reloadData()

            case .Failure(_):
                break
            }
        }
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
}

extension CreatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.sceneCollectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
        cell.reload()
        self.sceneImageView.image = cell.imageView.image
        setUpPageMenu(index: indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = self.sceneCollectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell? {
            cell.reload()
        }
    }
}

extension CreatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sceneURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SceneCollectionViewCell.reuseIdentifier, for: indexPath) as! SceneCollectionViewCell
        cell.info = SceneInform(url: sceneURL[indexPath.row], sceneNum: indexPath.row + 1)
        cell.reload()
        return cell
    }
    
}

extension CreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 16/9, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CreatorViewController: UIImageCropperProtocol{
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        sceneImageView.image = croppedImage
    }
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
    }
}
