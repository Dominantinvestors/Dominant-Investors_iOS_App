//
//  DMServerMainSignalsRequests.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 06.01.18.
//  Copyright © 2018 Dominant. All rights reserved.
//

import Foundation

extension DMServerAPIManager {

	open func getSignalCompaniesWith(limit:Int, offset:Int, completion : @escaping ([DMCompanyModel]) -> Void) {
		let endPoint = String(format : "%@/", Network.main)
		
		var params = [String : Int]()
		params["limit"] = limit
		params["offset"] = offset
		
		var headers = [String:String]()
		headers["X-CSRFToken"] = UserDefaults.standard.object(forKey: ConstantsUserDefaults.accessToken) as? String
		headers["Accept"] = "application/json"
		
		self.performRequest(endPoint: endPoint, method: .get, params: params, headers: headers) { (response, error) in
			print(response)
		}
		

    }

}
