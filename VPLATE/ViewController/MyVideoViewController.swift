//
//  MyVideoViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 3..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import PageMenu

class MyVideoViewController: ViewController {
    var pageMenu: CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = TitleEnum.myVideo.rawValue
        //
        setUpScrollMenu()
        // Do any additional setup after loading the view.
    }
    
    func setUpScrollMenu(){
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller2: InProgressViewController = InProgressViewController(nibName: InProgressViewController.reuseIdentifier, bundle: nil)
        controller2.title = "미완성 영상"
        controllerArray.append(controller2)
        
        
        let controller3: CompletionViewController = CompletionViewController(nibName: CompletionViewController.reuseIdentifier, bundle: nil)
        controller3.title = "완성된 영상"
        controllerArray.append(controller3)
        
        // Customize menu (Optional)
        let menuHeight:CGFloat = super.view.frame.height * 0.075// 50.0
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.black),
            .unselectedMenuItemLabelColor(UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)  ),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 12.0)!),
            .menuHeight(menuHeight),
            .menuItemWidth(80),
            .menuMargin(0),
            .selectionIndicatorHeight(0),
            .bottomMenuHairlineColor(UIColor.black),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .selectedMenuItemLabelColor(UIColor.black)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        
        self.view.addSubview(pageMenu!.view)
    }
    
    
}
