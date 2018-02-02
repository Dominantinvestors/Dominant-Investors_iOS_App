//
//  DMInvestmentSignalModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation

class DMInvestmentSignalModel: NSObject {

    var id          : String?
    var ticker      : String?
    var entry_price : String?
    var potential   : String?
    var stop_loss   : String?
    
    init(response : DMResponseObject) {
        super.init()
        
        if let respValue = response.id {
            self.id       = respValue
        }
        
        if let respValue = response.fields["ticker"] as? String {
            self.ticker  = respValue
        }
        
        if let respValue = response.fields["entry_price"] as? String {
            self.entry_price  = respValue
        }
        
        if let respValue = response.fields["potential"] as? String {
            self.potential  = respValue
        }
        
        if let respValue = response.fields["stop_loss"] as? String {
            self.stop_loss  = respValue
        }
        

    }
    
}
