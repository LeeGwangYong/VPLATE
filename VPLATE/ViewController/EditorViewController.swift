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
    var delegate: CreatorViewController?
    var keyboardDismissGesture: UITapGestureRecognizer?

    static var datas:[Int:Data] = [:]
    var type: ClipType!
    var editData: [ClipInfo]! {
        didSet {
            switch type{
            case .video?:
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = false
            case .picture?:
                cropper.picker = picker
                picker.mediaTypes = [kUTTypeImage as String]
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
        self.setUpCollectionView(collectionView: editorCollectionView, cell: EditorTextCollectionViewCell.self)
        cropper.delegate = self
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        
        self.setKeyboardSetting()
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.editorCollectionView)
        guard let indexPath = self.editorCollectionView.indexPathForItem(at: tapLocation) else {return}
        self.selectedIndex = indexPath
        guard let data = editData![indexPath.row] as ClipInfo? else {return}
        self.cropper.cropRatio = CGFloat(data.constraint)
        if data.type != ClipType.text {
            self.parentNavigation?.present(self.picker, animated: true, completion: nil)
        }
        //액션 필수
    }
    
    override func loadAsset(_ asset: AVAsset, index: IndexPath) {
        guard let clip = self.editData[index.row] as ClipInfo? else {return}
        let duration = clip.constraint
        if asset.duration >= CMTime(seconds: duration, preferredTimescale: CMTimeScale(600)) {
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
        guard let clip = self.editData[selectedIndex.row] as ClipInfo? else {return}
        CreatorViewController.requestData[clip.index]??.type = clip.type
        CreatorViewController.requestData[clip.index]??.data = url
        CreatorViewController.displayData[clip.index] = url.getThumbnailImage()
        self.editorCollectionView.reloadData()
    }
}

extension EditorViewController: UIImageCropperProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        print(selectedIndex)
        guard let clip = self.editData[selectedIndex.row] as ClipInfo? else {return}
        CreatorViewController.requestData[clip.index]??.type = clip.type
        CreatorViewController.requestData[clip.index]??.data = croppedImage!
        CreatorViewController.displayData[clip.index] = croppedImage!
        //여기서 편집
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
        
        if editData[selectedIndex.row].type != ClipType.text {
            return CGSize(width: height * 1.2, height: height)
        }
        else { return CGSize(width: super.view.frame.width * 0.8, height: super.view.frame.height) }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let data = editData else {return 0}
        return editData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditorViewController.tapped(sender:)))
        if editData[indexPath.row].type != .text{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.reuseIdentifier, for: indexPath) as! EditorCollectionViewCell
            cell.imageView.addGestureRecognizer(tap)
            cell.numberLabel.text = "\(editData[indexPath.row].index)"
            if let index = editData[indexPath.row].index as Int?{
                if CreatorViewController.displayData[index] != nil {
                    if let img: UIImage = CreatorViewController.displayData[index]!  {
                        cell.imageView.image = img
                    }
                }
            }
            else {
                cell.imageView.image = editData[indexPath.row].type == ClipType.video ? #imageLiteral(resourceName: "ic_movie_creation_white_48px"): #imageLiteral(resourceName: "ic_image_white_48px")
            }
            cell.data = "\(indexPath.row)"
            switch editData[indexPath.row].type {
            case .video:
                cell.timeLabel.isHidden = false
                cell.timeLabel.text = Int(editData[indexPath.row].constraint).IntToMMSS()
            case .picture:
                cell.timeLabel.isHidden = true
            case .text:
                cell.timeLabel.isHidden = true
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorTextCollectionViewCell.reuseIdentifier, for: indexPath) as! EditorTextCollectionViewCell
        
        cell.textField.addGestureRecognizer(tap)
        cell.numberLabel.text = "\(editData[indexPath.row].index)"
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        cell.textField.delegate = self
        cell.constraintLabel.text = "( \(cell.textField.text?.count ?? 0)/\(Int(editData[indexPath.row].constraint)) )"
        if let str =  CreatorViewController.requestData[editData[indexPath.row].index]??.data as? String{
            cell.textField.text = str
        }
        else {cell.textField.text = ""}
        
        return cell
    }
}

extension EditorViewController: UITextFieldDelegate {
    func setKeyboardSetting()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.kyeboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.kyeboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    @objc func kyeboardWillShow(_ notification: Notification)
    {
        if let keyboadSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            adjustKeyboardDismissTapGesture(isKeyboardVisible: true)
            delegate?.bottomConstraint.constant = keyboadSize.height
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval{
                UIView.animate(withDuration: animationDuration, animations: { self.view.layoutIfNeeded()})
            }
            self.view.layoutIfNeeded()
            self.delegate?.view.layoutIfNeeded()
        }
    }
    @objc func kyeboardWillHide(_ notification: Notification)
    {
        if let keyboadSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            delegate?.bottomConstraint.constant = 0
            
            if let animationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval{
                UIView.animate(withDuration: animationDuration, animations: { self.view.layoutIfNeeded()})
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool){
        if isKeyboardVisible{
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
                delegate?.view.addGestureRecognizer(keyboardDismissGesture!)
                self.view.addGestureRecognizer(keyboardDismissGesture!)
            }
        }
        else{
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                delegate?.view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if let data = editData[selectedIndex.row] as ClipInfo? {
            if let cell = self.editorCollectionView.cellForItem(at: selectedIndex) as! EditorTextCollectionViewCell? {
                if cell.textField == textField {
                    cell.constraintLabel.text = "( \(newLength)/\(Int(data.constraint)))"
                    
                    if newLength <= Int(data.constraint) {
                        cell.constraintLabel.textColor = UIColor.black
                        CreatorViewController.requestData[data.index]??.type = data.type
                        CreatorViewController.requestData[data.index]??.data = text
                        return true
                    }
                    else {
                        cell.constraintLabel.textColor = UIColor(red: 252/255, green: 85/255, blue: 59/255, alpha: 1)
                        CreatorViewController.requestData[data.index]??.type = data.type
                        CreatorViewController.requestData[data.index]??.data = text
                        return false
                    }
                }
                return false
            }
            return false
        }
        return false
    }
    
}

