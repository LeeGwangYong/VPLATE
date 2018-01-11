//
//  TemplateListServiece.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 9..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

struct TemplateListServiece: APIService {
    static func getTemplateList(url: String,method: HTTPMethod,parameter: [String : Any]?, header: HTTPHeaders,completion: @escaping (Result<Any>)->()) {
        let url = self.getURL(path: url)
        let encoding: ParameterEncoding = method == .get ?  URLEncoding.queryString : JSONEncoding.default
        Alamofire.request(url, method: method, parameters: parameter, encoding: 
            encoding, headers: header).responseData { (response) in
            print(response.request?.url)
            guard let resultData = getResult_StatusCode(response: response) else {
                return
            }
            print(resultData)
            completion(resultData)
        }
    }
    
}
