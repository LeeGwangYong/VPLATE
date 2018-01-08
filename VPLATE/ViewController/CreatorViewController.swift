//
//  CreatorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CreatorViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var sceneCollectionView: UICollectionView!
    @IBOutlet weak var sceneImageView: UIImageView!
    
    let picker = UIImagePickerController()
    let cropper = UIImageCropper(cropRatio: 16/9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView(collectionView: sceneCollectionView, cell: SceneCollectionViewCell.self)
        cropper.picker = picker
        cropper.delegate = self
        cropper.cropRatio = 16/9
    }

    @IBAction func takePicture(_ sender: UIButton) {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
}
extension CreatorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SceneCollectionViewCell
        print(cell.data)
    }
}

extension CreatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SceneCollectionViewCell.reuseIdentifier, for: indexPath) as! SceneCollectionViewCell

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
