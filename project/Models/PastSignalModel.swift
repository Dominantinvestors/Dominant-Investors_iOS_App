//
//  PastSignalModel.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import Foundation
import ObjectMapper

struct PastSignalModel: Mappable, Hashable {
    
    var totalTransactions: Int = 0
    var avg: Double = 0.0
    var totalProfit: Double = 0.0
    var data: [PastSignalData] = []
    
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        totalTransactions <- map["total_transactions"]
        avg <- map["avg"]
        totalProfit <- map["total_profit"]
        data <- map["data"]
    }
}

struct PastSignalData: Mappable, Hashable {
    
    var asset: Int = 0
    var buyPoint: Double = 0
    var sellPoint: Double = 0
    var profitability: Double = 0
    var ticker: String = ""
    
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        asset <- map["asset"]
        buyPoint <- map["buy_point"]
        sellPoint <- map["sell_point"]
        profitability <- map["profitability"]
        ticker <- map["ticker"]
    }
}
