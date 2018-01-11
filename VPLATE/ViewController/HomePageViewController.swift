//
//  HomePageViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 11..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON

class HomePageViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var nonImageView: UIImageView!
    var parentNavigation: UINavigationController?
    var templateList: [Template] = []
    var sort: Sort!
    var cursor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView(tableView: self.videoTableView, tableViewCell: VideoTableViewCell.self)
        nonImageView.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTemplateList()
    }
    
    func fetchTemplateList() {
        let parameter: [String:Any] = ["type" : HomeViewController.selectedCategory.rawValue,
                                       "cursor" : self.cursor]
        let sortValue = self.sort.rawValue
        
        TemplateListServiece.getTemplateList(url: "account/template/list/"+sortValue, method: .get, parameter: parameter, header: Token.getToken()) { (response) in
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
                    
                    self.videoTableView.reloadData()
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


extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        UIView.animate(withDuration: 1) {
            self.nonImageView.alpha = self.templateList.count>0 ? 0 : 1
            //self.view.layoutIfNeeded()
        }
        return templateList.count
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        if endScrolling >= scrollView.contentSize.height {
            print("Scroll End")
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getNextViewController(viewController: DetailViewController.self) as! DetailViewController
        vc.info = templateList[indexPath.row]
        self.parentNavigation?.pushViewController(vc, animated: true)
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath) as! VideoTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.info = templateList[indexPath.row]
        cell.cellType = CellType.template
        return cell
    }
    
}
