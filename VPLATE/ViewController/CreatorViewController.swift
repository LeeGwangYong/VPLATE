//
//  CreatorViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 6..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import PageMenu

class CreatorViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    var currentCellIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollMenu()
    }
    
    func setUpScrollMenu(){
        // Initialize view controllers to display and place in array
        var controllerArray : [PageViewController] = []
        
        
        for item in 1...5 {
            let controller:SceneViewController = SceneViewController(nibName: SceneViewController.reuseIdentifier, bundle: nil)
            controller.title = "SCENE \(item)"
            controller.parentNavigationController = self.navigationController
            controller.info = "SCENE \(item)"
            controllerArray.append(controller)
        }
        
        // Customize menu (Optional)
        let menuHeight:CGFloat = 50.0
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.red),
            .unselectedMenuItemLabelColor(UIColor.lightGray.withAlphaComponent(0.5)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
            .menuHeight(menuHeight),
            .menuItemWidth(self.view.frame.width/3),
            .menuMargin(0),
            .selectionIndicatorHeight(5.0),
            .bottomMenuHairlineColor(UIColor.orange),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.black)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
    }
    
    

}

