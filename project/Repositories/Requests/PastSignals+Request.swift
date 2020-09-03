//
//  PastSignals+Request.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import Foundation

extension PastSignalModel {
    
    static func get() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/trade-signals/")
    }
    
    static func get(startDate: String, endDate: String) -> RequestProvider {
        let parameters: [String: Any] = ["start_date": startDate,
                                         "end_date": endDate]
        return URLEncodingRequestBuilder(path: "/trade-signals/", parameters: parameters)
    }
}
