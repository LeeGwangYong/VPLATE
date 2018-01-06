//
//  CreatorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class CreatorViewController: UIViewController, ViewControllerProtocol {

    @IBOutlet weak var sceneNameCollectionView: UICollectionView!
    @IBOutlet weak var sceneCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView(collectionView: sceneCollectionView, cell: CreatorCollectionViewCell.self)
        self.sceneCollectionView.isPagingEnabled = true
    }
}

extension CreatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
}

extension CreatorViewController: UICollectionViewDelegate {
    
}

extension CreatorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatorCollectionViewCell.reuseIdentifier, for: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        <#code#>
    }
    
    
    
}
