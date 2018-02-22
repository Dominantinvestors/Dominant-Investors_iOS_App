//
//  DMServerAPIManager.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 06.01.18.
//  Copyright © 2018 Dominant. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class DMServerAPIManager : NSObject {
    
    static let sharedInstance = DMServerAPIManager()
    var reachability : NetworkReachabilityManager!
    
    override init() {
        super.init()
        self.setupReachability()
    }
    
    //MARK: Reachability
    
    private func setupReachability() {
        self.reachability = NetworkReachabilityManager.init(host: String(format : "%@/%@/" , Network.baseURL, Network.APIVersion))
        self.reachability.listener = { status in
            
        }
        self.reachability.startListening()
    }
    
    open func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Base request
    
    public func performRequest(endPoint : String,
                                method : HTTPMethod,
                                params : [String : Any]? = nil,
                                headers : HTTPHeaders? = nil,
                                completion : @escaping ([String : Any]?, NSError?) -> Void) {
        
        if (self.isInternetAvailable() == true) {
            
            let url = String(format : "%@/%@/" , Network.baseURL, Network.APIVersion).appending(endPoint)
            
            Alamofire.request(url, method: method, parameters: params, headers: headers).responseJSON(completionHandler: { (response) in
                
                if (response.result.value != nil) {
                    if let resultJSON = response.result.value as? [String : Any] {
                        if (resultJSON["error_code"] as? NSNumber) != nil {
                            //completion(nil, self.getErrorFrom(code: errorCode))
                        } else {
                            completion(resultJSON, nil)
                        }
                    }
                }
            })
        } else {
            let description = "Please check internet connection".localized
            let userInfo = [NSLocalizedDescriptionKey : description]
            let error = NSError.init(domain: "Connection error".localized, code: 999, userInfo: userInfo)
            completion(nil, error)
        }
        
    }
    
}
