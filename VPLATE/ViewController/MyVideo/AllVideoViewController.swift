//
//  AllVideoViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class AllVideoViewController: UIViewController, ViewControllerProtocol  {
    @IBOutlet weak var videoTableView: UITableView!
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView(tableView: videoTableView, tableViewCell: VideoTableViewCell.self)
    }
}


extension AllVideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: CreatorViewController.reuseIdentifier)
        self.parentNavigationController?.pushViewController(nextVC, animated: true)
    }
}

extension AllVideoViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath)
    }
}
