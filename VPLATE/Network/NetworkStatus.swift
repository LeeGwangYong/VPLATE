//
//  NetworkStatus.swift
//  VPLATE
//
//  Created by 이광용 on 2018. 1. 11..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import Alamofire

class NetworkStatus {
    static let sharedInstance = NetworkStatus()
    
    private init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                let alertController = UIAlertController(title: "네트워크",
                                                        message: """
네트워크 연결이 해제되었습니다.
확인을 누르면 어플이 종료됩니다.
""",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    exit(0)
                }
                alertController.addAction(okAction)
                UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
            }
        }
        reachabilityManager?.startListening()
    }
}
