//
//  SignServiece.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 9..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SignService: APIService {
    static func getSignData(url: String, parameter: [String : Any]?, completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            guard let resultData = getResult_StatusCode(response: response) else {return}
            completion(resultData)
        }
    }
}
//"http://13.124.195.255:3003/account/signin"
//- key : "email"
//- some : "rhkddydkrfl2@naver.com"
//- key : "pwd"
//- some : "1517875735000727"
//- key : "fcm_key"
//- value : nil

