//
//  HomeViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit


class HomeViewController: ViewController, ViewControllerProtocol {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var homeVideoTableView: UITableView!
    @IBOutlet weak var categoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    var categoryConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categoryHeight: CGFloat!
    var openCategory: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleEnum.home.rawValue
        categoryConstraints = [categoryViewHeightConstraint, mainViewTopConstraint]
        self.setUpTableView(tableView: homeVideoTableView, tableViewCell: VideoTableViewCell.self)
        self.setUpCollectionView(collectionView: categoryCollectionView, cell: CategoryCollectionViewCell.self)
        categoryHeight = super.view.frame.height * 0.09
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        categoryVisible(target: categoryConstraints, value: 0)
        openCategory = false
    }

    
    func categoryVisible(target: [NSLayoutConstraint] ,value: CGFloat){
        for item in target {
            item.constant = value
        }
    }
    
    
    @IBAction func openCategoryAction(_ sender: UIBarButtonItem) {
        openCategory = openCategory ? false:true
        if openCategory {
            self.categoryVisible(target: self.categoryConstraints, value: categoryHeight)
        }
        else {
            self.categoryVisible(target: self.categoryConstraints, value: 0)
        }
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath) as! VideoTableViewCell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryHeight, height: categoryHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Category Selected Index : \(indexPath)")
        for cell in collectionView.visibleCells as! [CategoryCollectionViewCell]{
            cell.reload()            
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Category DeSelected Index : \(indexPath)")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.backgroundImageView.backgroundColor = UIColor().random()
        cell.reload()
        return cell
    }
    
    
}
