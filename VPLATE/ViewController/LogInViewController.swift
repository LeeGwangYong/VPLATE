//
//  LogInViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 8..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpButton.imageView?.tintColor = UIColor.black
        
    }
    @IBAction func facebookAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let next = storyBoard.instantiateViewController(withIdentifier: TabBarController.reuseIdentifier)
        self.present(next, animated: true, completion: nil)
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
//        if sender.isFocused {
//            sender.imageView?.tintColor = UIColor.lightGray
//        }
//        else {
//            sender.imageView?.tintColor = UIColor.black
//        }
    }
}
