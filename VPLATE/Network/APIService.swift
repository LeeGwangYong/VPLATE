//
//  APIServiece.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 9..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    case Success(T)
    case Failure(Int)
}
struct Token {
    static func getToken() -> [String:String]{
        guard let token = UserDefaults.standard.string(forKey: "token") else {return ["tt" : "Not exist Token"]}
        
        return ["tt" : token]
    }
}
protocol APIService {
    
}

extension APIService  {
    static func getURL(path: String) -> String {
        return "http://13.124.195.255:3003/" + path
    }
    static func getResult_StatusCode(response: DataResponse<Data>) -> Result<Any>? {
        switch response.result {
        case .success :
            guard let statusCode = response.response?.statusCode as Int? else {return nil}
            guard let responseData = response.data else {return nil}
            switch statusCode {
            case 200..<400 :
                return Result.Success(responseData)
            default :
                return Result.Failure(statusCode)
            }
        case .failure(let err) :
            print(err.localizedDescription)
        }
        return nil
    }
}
