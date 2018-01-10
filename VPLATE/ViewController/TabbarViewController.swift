//
//  TabbarViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 4..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class TabbarViewController: UIViewController, ViewControllerProtocol {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextViewController = getNextViewController(viewController: CommunityViewController.self) as? CommunityViewController else{return}
        nextViewController.tableViewIndex = tabBarController?.selectedIndex
        self.present(nextViewController, animated: true, completion: nil)
    }
}
