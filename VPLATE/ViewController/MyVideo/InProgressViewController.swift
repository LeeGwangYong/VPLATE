//
//  InProgressViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class InProgressViewController: UIViewController, ViewControllerProtocol {

    @IBOutlet weak var videoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView(tableView: videoTableView, tableViewCell: VideoTableViewCell.self)
    }
}

extension InProgressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getReusableCell(tableView: tableView, cell: VideoTableViewCell.self, indexPath: indexPath)
    }
}

extension InProgressViewController: UITableViewDelegate {
    
}
