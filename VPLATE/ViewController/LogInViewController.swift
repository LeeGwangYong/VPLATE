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
import SwiftyJSON
import SwiftGifOrigin

struct UserDataRequest: GraphRequestProtocol
{
    public let graphPath = "me"
    public let parameters: [String:Any]? = ["fields" : "id, email, name, picture{url}"]
    public let accessToken: AccessToken? = AccessToken.current
    public let httpMethod: GraphRequestHTTPMethod = .GET
    public let apiVersion: GraphAPIVersion = GraphAPIVersion.defaultVersion
    
    struct Response: GraphResponseProtocol{
        var id = ""
        var email = ""
        var name = ""
        var profileURL = ""
        init(rawResponse: Any?){
            if let data = rawResponse as? [String:Any]
            {
                if let id = data["id"]{
                    self.id = id as! String
                }
                if let email = data["email"]{
                    self.id = email as! String
                }
                
                if let name = data["name"]{
                    self.name = name as! String
                }
                
                if let profileURL = (data["picture"] as? [String: [String:String]])?["data"]?["url"]{
                    self.profileURL = profileURL
                }
                
            }
        }
    }
}

class LogInViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var signUpButton: UIButton!
    let fbLoginManager = LoginManager()
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backImageView.loadGif(name: <#T##String#>)
    }
    override func viewDidAppear(_ animated: Bool) {
        navigateAccesToken()
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _) :
                self.getFaceBookUserData()
            case .failed(let err) :
                print(err.localizedDescription)
            case .cancelled :
                print("Cancelled")
                break
            }
        }
    }
    
    var userData: UserDataRequest.Response?
    func getFaceBookUserData() {
        guard let fbToken = FBSDKAccessToken.current() else {
            print("Facebook Token Error")
            return
        }
        
        let connection = GraphRequestConnection()
        connection.add(UserDataRequest()) {
            (response: HTTPURLResponse?, result: GraphRequestResult<UserDataRequest>) in
            switch result {
            case .success(let graphResponse) :
                self.userData = graphResponse
                print("Facebook User Data : \(self.userData)")
                guard let email = self.userData?.id else {return}
                self.signIn(email: email, pw: fbToken.userID, fcmKey: nil)
            case .failed :
                break
            }
        }
        connection.start()
    }
    
    func navigateAccesToken(){
        if let _ = UserDefaults.standard.value(forKey: "token") {
            self.present(self.getNextViewController(viewController: TabBarController.self), animated: true, completion: nil)
        }
    }
    
    //로그아웃
    //UserDefaults.standard.removeObject(forKey: "id")
    //delete token : fbLoginManager.logOut()
    
    func signIn(email: String, pw: String, fcmKey: String?){
        let parameter = ["email" : email,
                         "outside_key" : pw,
                         "fcm_key" : fcmKey]
        SignService.getSignData(url: "account/signin", parameter: parameter) { (result) in
            switch result {
            case .Success(let response):
                guard let data = response as? Data else {return}
                let dataJSON = JSON(data)
                print(dataJSON)
                let token = dataJSON["token"].string
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(pw, forKey: "pw")
                UserDefaults.standard.set(token, forKey: "token")
                
                self.navigateAccesToken()
            case .Failure(let failureCode):
                print("Sign In Failure : \(failureCode)")
                if failureCode == 500 { print("Disconnect Network")}
                else {
                    self.signUp()
                }
            }
        }
    }
    
    func signUp() {
        guard let userData = userData else {return}
        let parameter: [String : Any] = ["type" : 2,
                                            "email" : userData.id,
                                            "name" : userData.name,
                                            "nickname" : userData.name,
                                            "profile" : userData.profileURL,
                                            "outside_key" : FBSDKAccessToken.current().userID]
        SignService.getSignData(url: "account/signup", parameter: parameter) { (result) in
            switch result {
            case .Success(let response):
                //print(response)
                self.signIn(email: "Email", pw: FBSDKAccessToken.current().userID, fcmKey: nil)
            case .Failure(let failureCode):
                print("Sing Up Failure : \(failureCode)")
                if failureCode >= 500 { print("Disconnect Network")}
                
            }
        }
    }
    
    
}

