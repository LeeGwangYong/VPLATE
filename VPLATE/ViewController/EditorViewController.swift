//
//  EditorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Toast_Swift

class EditorViewController: AssetSelectorViewController, ViewControllerProtocol {
    @IBOutlet weak var editorCollectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    var parentNavigation: UINavigationController?
    var videoURL: [String] = []
    var imageDatas: [UIImage] = []
    static var datas:[Int:Data] = [:]
    var type: ClipType!
    var editData: [ClipInfo]! {
        didSet {
            let count = editData.count
            switch type{
            case .video?:
                for _ in 0 ..< count {
                    imageDatas.append( #imageLiteral(resourceName: "ic_movie_creation_white_48px") )
                }
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = false
            case .picture?:
                for _ in 0 ..< count {
                    imageDatas.append( #imageLiteral(resourceName: "ic_image_white_48px") )
                }
                cropper.picker = picker
                picker.mediaTypes = [kUTTypeImage as String]
                break
            case .text?:
                break
            case .none:
                break
            }
        }
    }
    var selectedIndex = IndexPath(row: 0, section: 0)
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    var img: UIImage = #imageLiteral(resourceName: "icon_VIDEO")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView(collectionView: editorCollectionView, cell: EditorCollectionViewCell.self)
        cropper.delegate = self
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.editorCollectionView)
        guard let indexPath = self.editorCollectionView.indexPathForItem(at: tapLocation) else {return}
        self.selectedIndex = indexPath
        guard let data = editData![indexPath.row] as ClipInfo? else {return}
        self.cropper.cropRatio = CGFloat(data.constraint)
        
        self.parentNavigation?.present(self.picker, animated: true, completion: nil)
    }
    
    override func loadAsset(_ asset: AVAsset, index: IndexPath) {
        guard let clip = self.editData[index.row] as ClipInfo? else {return}
        let duration = clip.constraint
        if asset.duration > CMTime(seconds: duration, preferredTimescale: CMTimeScale(600)) {
            let trimmerVC: TrimmingViewController = TrimmingViewController(nibName: TrimmingViewController.reuseIdentifier, bundle: nil)
            
            trimmerVC.asset = asset
            trimmerVC.duration = duration
            trimmerVC.delegate = self
            
            self.parentNavigation?.present(trimmerVC, animated: true, completion: nil)
        }
        else {
            self.view.makeToast( """
영상의 길이가 너무 짧습니다.
다른 영상을 선택해주세요.
""", duration: 3, position: .center, style: ToastStyle())
        }
    }
    
    func getAssetData(asset: AVAsset, url: URL) {
        imageDatas[selectedIndex.row] = url.getThumbnailImage()!
        self.editorCollectionView.reloadData()
    }
}

extension EditorViewController: UIImageCropperProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        print(selectedIndex)
        imageDatas[selectedIndex.row] = croppedImage!
        self.editorCollectionView.reloadData()
    }
    
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if let videoURL = info[UIImagePickerControllerMediaURL] as! URL? {
            self.parentNavigation?.dismiss(animated: true, completion: {
                if mediaType == kUTTypeMovie {
                    self.loadAsset(AVAsset(url: videoURL), index: self.selectedIndex)
                }
            })
        }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.cropper.image = image.fixOrientation()
            self.picker.present(cropper, animated: true, completion: nil)
        }
        
    }
    
}

extension EditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = super.view.frame.height * 0.5
        return CGSize(width: height * 1.2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let data = editData else {return 0}
        return editData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.reuseIdentifier, for: indexPath) as! EditorCollectionViewCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditorViewController.tapped(sender:)))
        cell.imageView.addGestureRecognizer(tap)
        cell.imageView.image = imageDatas[indexPath.row]
        cell.data = "\(indexPath.row)"
        return cell
    }
}

