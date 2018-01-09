//
//  LogInViewController.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 8..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Alamofire

struct UserDataRequest: GraphRequestProtocol{
    public let graphPath: String = "me"
    public let parameters: [String : Any]? = ["fields" : "id, email, name, picture[url]"]
    public let accessToken: AccessToken? = AccessToken.current
    public let httpMethod: GraphRequestHTTPMethod = .GET
    public let apiVersion: GraphAPIVersion = GraphAPIVersion.defaultVersion
    
    struct Response: GraphResponseProtocol {
        var id = ""
        var email = ""
        var name = ""
        var profileURL = ""
        init(rawResponse: Any?) {
            guard let data = rawResponse as? [String:Any] else {return}
            if let id = data["id"] { self.id = id as! String}
            if let email = data["email"] { self.email = email as! String}
            if let name = data["name"] { self.name = name as! String}
            if let profileURL = (data["pictures"] as? [String: [String: String]])?["data"]?["url"] { self.profileURL = profileURL}
        }
    }
}

class LogInViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpButton.imageView?.tintColor = UIColor.black
        
    }
    @IBAction func facebookAction(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _) :
                self.getFaceBookUserData()
                self.present(self.getNextViewController(viewController: TabBarController.self), animated: true, completion: nil)
                break
            case .failed(let err) :
                print(err.localizedDescription)
            case .cancelled :
                print("Cancelled")
                break
            }
        }
    }
    
    var userData: UserDataRequest.Response?
    func getFaceBookUserData(){
        guard let fbToken = FBSDKAccessToken.current()
            else {
                print("Facebook Token Error")
                return
        }
        let connection = GraphRequestConnection()
        connection.add(UserDataRequest()) {
            (response: HTTPURLResponse?, result: GraphRequestResult<UserDataRequest>) in
            switch result {
            case .success(let graphResponse) :
                self.userData = graphResponse
                print(self.userData)
                break
            case .failed :
                break
            }
        }
    }
    
    func signUp(data: UserDataRequest.Response) {
        let parameter = ["email" : "",
                         "name" : data.name,
                         "nickname" : data.name,
                         "profile" : data.profileURL,
                         "outside_key" : data.id]
        SignService.getSignData(url: "account/signup", parameter: parameter) { (result) in
            switch result {
            case .Success(let response):
                print(response)
            case .Failure(let failureCode):
                print("Sing Up Failure : \(failureCode)")
            }
        }
    }
    
    func signIn(id: String, pw: String, fcmKey: String){
        let parameter = ["email" : id,
                         "pwd" : pw,
                         "fcm_key" : fcmKey]
        SignService.getSignData(url: "account/signin", parameter: parameter) { (result) in
            switch result {
            case .Success(let response):
                print(response)
            case .Failure(let failureCode):
                print("Sign In Failure : \(failureCode)")
            }
        }
    }
}

