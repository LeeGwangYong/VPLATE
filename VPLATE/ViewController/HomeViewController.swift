//
//  HomeViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON
import PageMenu

enum Sort: String{
    case latest = "latest"
    case popularity = "popularity"
}
enum Category: String {
    case all = "all"
    case product = "제품"
    case travel = "여행"
    case cafe = "카페"
    case foodTruck = "푸드트럭"
    case event = "행사"
    
    var english: String {
        switch self {
        case .all : return "all"
        case .product : return "product"
        case .travel : return "travel"
        case .cafe : return "cafe"
        case .foodTruck : return "foodtruck"
        case .event : return "event"
        }
    }
}

class HomeViewController: ViewController, ViewControllerProtocol {
    var category: [Category] = [Category.all,
                                Category.product,
                                Category.travel,
                                Category.cafe,
                                Category.foodTruck,
                                Category.event]
    static var selectedCategory: Category = Category.all
    var sort: Sort = Sort.latest
    var cursor: Int = 0
    var templateList: [Template] = []
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var categoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    var categoryConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categoryHeight: CGFloat!
    var openCategory: Bool = false
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "vplate.png"))
        
        categoryConstraints = [categoryViewHeightConstraint, mainViewTopConstraint]
        self.setUpCollectionView(collectionView: categoryCollectionView, cell: CategoryCollectionViewCell.self)
        categoryHeight = super.view.frame.height * 0.1
        
        self.navigationItem.title = ""
        self.categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        if #available(iOS 10.0, *) {
            self.categoryCollectionView.isPrefetchingEnabled = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        categoryVisible(target: categoryConstraints, value: 0)
        openCategory = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpPageMenu()
        self.setNeedsFocusUpdate()
    }
    
    func categoryVisible(target: [NSLayoutConstraint] ,value: CGFloat){
        for item in target {
            item.constant = value
        }
    }
    
    var pageMenu: CAPSPageMenu?
    
    func setUpPageMenu(){
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1: HomePageViewController = HomePageViewController(nibName: HomePageViewController.reuseIdentifier, bundle: nil)
        controller1.title = "최신순"
        controller1.sort = .latest
        controller1.parentNavigation = self.navigationController
        controllerArray.append(controller1)
        
        let controller2: HomePageViewController = HomePageViewController(nibName: HomePageViewController.reuseIdentifier, bundle: nil)
        controller2.title = "인기순"
        controller2.parentNavigation = self.navigationController
        controller2.sort = .popularity
        controllerArray.append(controller2)

        let menuHeight:CGFloat = super.view.frame.height * 0.075// 50.0
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor.lightGray),
                //UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)  ),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 12.0)!),
            .menuHeight(menuHeight),
            .menuItemWidth(80),
            .menuMargin(0),
            .selectionIndicatorHeight(0),
            .bottomMenuHairlineColor(UIColor.black),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.black),
            
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray,
                                frame: CGRect(x: 0.0, y: 0.0, width: self.menuView.frame.width, height: self.menuView.frame.height),
                                pageMenuOptions: parameters)
        
        
        self.menuView.addSubview(pageMenu!.view)
        //self.view.setNeedsLayout()
        
    }

    @IBAction func openCategoryAction(_ sender: UIBarButtonItem) {
        openCategory = openCategory ? false:true
        if openCategory {
            self.categoryVisible(target: self.categoryConstraints, value: categoryHeight)
        }
        else {
            self.categoryVisible(target: self.categoryConstraints, value: 0)
        }
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
        guard let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell? else {return}
        cell.reload()
        HomeViewController.selectedCategory = category[indexPath.row]
        let p = pageMenu?.childViewControllers as! [HomePageViewController]
        p[0].fetchTemplateList()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell? {
            cell.reload()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        let name = category[indexPath.row]
        guard let img = UIImage(named: name.english) else {
            return UICollectionViewCell()}
        cell.backgroundImageView.image = img
        return cell
    }
    
}
