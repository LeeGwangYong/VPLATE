//
//  EditorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class EditorViewController: AssetSelectorViewController, ViewControllerProtocol {
    @IBOutlet weak var editorCollectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    var parentNavigation: UINavigationController?
    var videoURL: [String] = []
    var imageDatas: [UIImage] = []
    var editData: EditorDetailData? {
        didSet {
            let count = editData?.indexRatio.count
            cropper.delegate = self
            
            switch editData?.type{
            case .video?:
                for _ in 0 ..< count! {
                    imageDatas.append( #imageLiteral(resourceName: "ic_movie_creation_white_48px") )
                }
            case .picture?:
                for _ in 0 ..< count! {
                    imageDatas.append( #imageLiteral(resourceName: "ic_image_white_48px") )
                }
                self.picker.sourceType = .photoLibrary
                cropper.picker = picker
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
    }
    
    @objc func selectCell(indexPath: IndexPath) {
        selectedIndex = indexPath
        self.parentNavigation?.present(self.picker, animated: true, completion: nil)
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.editorCollectionView)
        guard let indexPath = self.editorCollectionView.indexPathForItem(at: tapLocation) else {return}
        self.selectedIndex = indexPath
        guard let data = editData?.indexRatio[indexPath.row + 1] else {return}
        self.cropper.cropRatio = data!
        self.parentNavigation?.present(self.picker, animated: true, completion: nil)
        //let cell = self.editorCollectionView.cellForItem(at: indexPath!) as! EditorCollectionViewCell
    }
}

extension EditorViewController: UIImageCropperProtocol{
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        print(selectedIndex)
        imageDatas[selectedIndex.row] = croppedImage!
        self.editorCollectionView.reloadData()
    }
    
    
    func didCancel() {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = super.view.frame.height * 0.5
        return CGSize(width: height * 1.2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let data = editData else {return 0}
        return imageDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.reuseIdentifier, for: indexPath) as! EditorCollectionViewCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditorViewController.tapped(sender:)))
        cell.imageView.addGestureRecognizer(tap)
    
        cell.imageView.image = imageDatas[indexPath.row]
        return cell
    }
}

