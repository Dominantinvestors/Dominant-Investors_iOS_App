//
//  DMServerAuthRequests.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 06.01.18.
//  Copyright © 2018 Dominant. All rights reserved.
//

import Foundation

extension DMServerAPIManager {
    
    //MARK: - Authorization requests
    
    open func loginWith(login : String, password : String, completion : @escaping (Bool, NSError?) -> Void) {
        
        let endPoint = String(format : "%@/%@", Network.authAPIModule, Network.loginEndPoint)
        
        var params = [String : String]()
        params["username"] = login
        params["password"] = password
        
        self.performRequest(endPoint: endPoint, method: .post, params : params) { (response, error) in
			if let correctResponse = response {
//                let userModel = DMUserProfileModel.init(response: DMResponseObject.init(response: correctResponse))
//				DMAuthorizationManager.sharedInstance.userID = UInt(userModel.userID)!
//                DMAuthorizationManager.sharedInstance.userProfile = userModel
//                let data  = NSKeyedArchiver.archivedData(withRootObject: userModel)
//                UserDefaults.standard.set(data, forKey : ConstantsUserDefaults.authorized)
//                UserDefaults.standard.set(DMAuthorizationManager.sharedInstance.userID, forKey : "user_id")
				let token = correctResponse["token"] as? String
				UserDefaults.standard.set(token, forKey: ConstantsUserDefaults.accessToken)

                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    open func signUpWith(login : String, email : String, password : String, confirm : String , inviterID : String?, completion : @escaping (Bool, NSError?) -> Void) {
        
    }
    
//    open func signOut() {
//        if let token = DMAuthorizationManager.sharedInstance.token {
//            let endPoint = String(format : "%@/%@", Network.authAPIModule, Network.logoutEndPoint)
//            let headers = ["Authorization" : String(format : "Token %@", token)]
//            self.performRequest(endPoint: endPoint, method: .post, headers : headers, completion: { (response, error) in
//
//            })
//        }
//    }
	
}
