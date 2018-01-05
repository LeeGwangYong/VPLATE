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
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var homeVideoTableView: UITableView!
    
    @IBOutlet weak var categoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    var categoryConstraints: [NSLayoutConstraint]!
    
    var openCategory: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleEnum.home.rawValue
        categoryConstraints = [categoryViewHeightConstraint, mainViewTopConstraint]
        self.setUpTableView(tableView: homeVideoTableView, tableViewCell: VideoTableViewCell.self)
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
            self.categoryVisible(target: self.categoryConstraints, value: 60)
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
