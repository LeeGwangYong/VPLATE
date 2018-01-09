//
//  HomeViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    var selectedCategory: Category = Category.all
    var sort: Sort = Sort.latest
    var cursor: Int = 0
    var templateList: [Template] = []
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var homeVideoTableView: UITableView!
    
    @IBOutlet weak var categoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    var categoryConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categoryHeight: CGFloat!
    var openCategory: Bool = false
    
    @IBOutlet var sortButton: [UIButton]!
    @IBOutlet weak var latestButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeVideoTableView.separatorStyle = .none
        
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "vplate.png"))
        
        categoryConstraints = [categoryViewHeightConstraint, mainViewTopConstraint]
        self.setUpTableView(tableView: homeVideoTableView, tableViewCell: VideoTableViewCell.self)
        self.setUpCollectionView(collectionView: categoryCollectionView, cell: CategoryCollectionViewCell.self)
        
        categoryHeight = super.view.frame.height * 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for button in sortButton {
            if button == latestButton{
                templateListSortAction(button)
            }
        }
        
        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.left)
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
    
    @IBAction func templateListSortAction(_ sender: UIButton) {
        for button in sortButton {
            if (button == sender) {
                button.titleLabel?.textColor = UIColor.black
            }
            else {
                button.titleLabel?.textColor = UIColor.lightGray
            }
        }
        
        if sender == latestButton {
            self.sort = .latest
        } else {
            self.sort = .popularity
        }
        requestTemplateList(position: .top)
    }
    
    func requestTemplateList(position: UITableViewScrollPosition) {
        let parameter: [String:Any] = ["type" : self.selectedCategory.rawValue,
                                       "cursor" : self.cursor]
        let sortValue = self.sort.rawValue
        
        TemplateListServiece.getTemplateList(url: "account/template/list/"+sortValue, parameter: parameter, header: Token.getToken()) { (response) in
            switch response {
            case .Success(let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
            let template = dataJSON["data"]["template"].map({$0.1})
                let decoder = JSONDecoder()
                do {
                    self.templateList = try template.map({ (jsonData) -> Template in
                        let value = try decoder.decode(Template.self, from: jsonData.rawData())
                        return value
                    })
                    
                    self.homeVideoTableView.reloadData()
                    switch position {
                    case .top :
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.homeVideoTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    case .none:
                        break
                    case .middle:
                        break
                    case .bottom:
                        break
                    }
                }
                catch (let err) {
                    print(err.localizedDescription)
                }
            case .Failure( _):
                break
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        if endScrolling >= scrollView.contentSize.height {
            print("Scroll End")
            
        }
    }
    
    func cursorUpdate() {
         cursor = ((cursor % 10) + 1) * 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
//            if !isMoreData {
//                moreData = true
//                // call some method that handles more rows
//            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath) as! VideoTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.info = templateList[indexPath.row]
        return cell
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
        selectedCategory = category[indexPath.row]
        requestTemplateList(position: .top)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Category DeSelected Index : \(indexPath)")
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
