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
        return ["tt" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjowLCJlbWFpbCI6ImFkbWluQHZwbGF0ZS5jb20iLCJuYW1lIjoiYWRtaW4iLCJuaWNrbmFtZSI6ImFkbWluIiwiaWF0IjoxNTE1NDg1MzQxLCJleHAiOjE1MTgwNzczNDF9.RA4-krO8EiLuBWt6kTagqBrRC2_h5_4O54pnU9xBXgo"]
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
