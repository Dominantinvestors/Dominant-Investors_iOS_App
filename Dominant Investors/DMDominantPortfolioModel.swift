//
//  DMDominantPortfolioModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import Quickblox

class DMDominantPortfolioModel: NSObject {

    var id : String?
    var ticker : String?
    var exchange : String? 
    
    init(response : DMResponseObject) {
        super.init()
    

        if let respID = response.id {
            self.id       = respID
        }
        
        if let respTicker = response.fields["ticker"] as? String {
            self.ticker       = respTicker
        }
        
        if let respExchange = response.fields["exchange"] as? String {
            self.exchange       = respExchange
        }
        
    }
}
