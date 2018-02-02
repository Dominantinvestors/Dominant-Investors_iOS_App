//
//  DMSignalHistoryModel.swift
//  Dominant Investors
//
//  Created by Nekit on 18.06.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Quickblox

class DMSignalHistoryModel: NSObject {

    var id : String!
    var ticker        : String!
    var buyPoint      : String!
    var sellPoint     : String!
    var profitability : String!
    
    var profitly = false
    
    init(response : DMResponseObject) {
        super.init()
        
        self.id       = response.id
        
        if let ticker = response.fields["ticker"] as? String {
            self.ticker = ticker
        } else {
            self.ticker = ""
        }
        
        var buy  : Double = 0.0
        var sell : Double = 0.0
        
        if let buyPoint = response.fields["buyPoint"] as? Float {
            buy = Double(buyPoint)
            self.buyPoint = String(format : "%.2f", buyPoint)
        } else {
            self.buyPoint = ""
        }
        
        if let sellPoint = response.fields["sellPoint"] as? Float {
            self.sellPoint = String(format : "%.2f", sellPoint)
            sell = Double(sellPoint)
        } else {
            self.sellPoint = ""
        }
        
        let profit = DMCalculationService.sharedInstance.calculateProfitWith(oldPrice: buy, currentPrice: sell)
        
        if profit >= 0 {
           self.profitability = String(format : "%.2f%@", profit, "%")
           self.profitly = true
        } else {
           self.profitability = String(format : "%.2f%@", profit, "%")
           self.profitly = false
        }
        
        
        
    }
    
}
