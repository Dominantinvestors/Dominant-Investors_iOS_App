//
//  DMPersonalPortfolioModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation

class DMPersonalPortfolioModel: NSObject {

    var id          : String? 
    var ticker      : String?
    var entry_price : String?
    var userID      : String?
    
    var entry_date  : Date?
    
    init(response : DMResponseObject) {
        super.init()
        
        guard let fields = response.fields as? [String : Any] else { return }
        
        if let respID = response.id {
            self.id       = respID
        }
        
        if let respValue = fields["ticker"] as? String {
            self.ticker       = respValue
        }
        
        if let respValue = fields["entry_price"] as? String {
            self.entry_price       = respValue
        }
        
        if let respValue = fields["crt_at"] as? String {
            self.entry_date       = DMDateService.sharedInstance.dominantDateFrom(string: respValue)
        }
        
        if let respValue = response.userID {
            self.userID       = respValue
        }

    }
    
    init(stockSearch : StockSearchResult) {
        super.init()
        self.ticker = stockSearch.symbol
    }
    
}
