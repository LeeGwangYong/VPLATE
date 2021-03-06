//
//  CategoryListServiece.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 10..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

struct CommunityListServiece: APIService {
    static func getList(url: String, parameter: [String : Any]?, header: HTTPHeaders,completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        Alamofire.request(url, method: .get, parameters: parameter, encoding:
            URLEncoding.queryString, headers: header).responseData { (response) in
                print(response.request?.url)
                guard let resultData = getResult_StatusCode(response: response) else {
                    return
                }
                print(resultData)
                completion(resultData)
        }
    }
    
    //static func 
}
