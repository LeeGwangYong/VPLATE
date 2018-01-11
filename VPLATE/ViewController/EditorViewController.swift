//
//  EditorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 12..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var editorCollectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    
    
    var parentNavigation: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView(collectionView: editorCollectionView, cell: EditorCollectionViewCell.self)
    }
    
}

extension EditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = super.view.frame.height * 0.5
        return CGSize(width: height * 1.2, height: height)
        //super.view.frame.height * 0.2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditorCollectionViewCell.reuseIdentifier, for: indexPath) as! EditorCollectionViewCell
        return cell
    }
    
    
}

