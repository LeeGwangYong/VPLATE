//
//  SelectedVideoViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectedVideoViewController: ViewController, ViewControllerProtocol {
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteList: [Template] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleEnum.selected.rawValue
        self.setUpTableView(tableView: favoriteTableView, tableViewCell: VideoTableViewCell.self)
        // Do any additional setup after loading the view.
    }
    func fetchFavoriteList(){
        let parameter = ["cursor" : 0]
        TemplateListServiece.getTemplateList(url: "account/template/list/choice/", method: .get, parameter: parameter, header: Token.getToken()) { (response) in
            switch response {
            case .Success(let data):
                guard let data = data as? Data else {return}
                let dataJSON = JSON(data)
                let template = dataJSON["data"]["template"].map({$0.1})
                let decoder = JSONDecoder()
                do {
                    self.favoriteList = try template.map({ (jsonData) -> Template in
                        let value = try decoder.decode(Template.self, from: jsonData.rawData())
                        return value
                    })
                    self.favoriteTableView.reloadData()
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

extension SelectedVideoViewController: UITableViewDelegate{
    
}

extension SelectedVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath) as! VideoTableViewCell
        cell.info = favoriteList[indexPath.row]
        cell.cellType = .favorite
        return cell
    }
    
    
}
