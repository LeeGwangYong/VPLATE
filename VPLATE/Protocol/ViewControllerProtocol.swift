//
//  VCTableViewProtocol.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerProtocol {
}

extension ViewControllerProtocol {
    func getNextViewController(viewController: UIViewController.Type) -> UIViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: viewController.reuseIdentifier)
    }
}
extension ViewControllerProtocol where Self: UITableViewDataSource & UITableViewDelegate {
    func setUpTableView(tableView: UITableView, tableViewCell: UITableViewCell.Type){
        tableView.delegate = self
        tableView.dataSource = self
        //self.videoTableView.register(UINib(nibName: VideoTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: VideoTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: tableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: tableViewCell.reuseIdentifier)
    }
    
    func getReusableCell(tableView: UITableView, cell: UITableViewCell.Type, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath) 
    }
}

extension ViewControllerProtocol where Self: UICollectionViewDataSource & UICollectionViewDelegate {
    func setUpCollectionView(collectionView: UICollectionView, cell: UICollectionViewCell.Type){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cell.reuseIdentifier, bundle: nil) , forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
}

