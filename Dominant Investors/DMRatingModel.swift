//
//  DMRatingModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import Quickblox

class DMRatingModel: NSObject {

    var id               : String?
    var userID           : String?
    var userName         : String?
    var invesmentStocks  = [DMPersonalPortfolioModel]()
    var totalValue       = 0.0
    var position : Int   = 1
    
    init(response : DMResponseObject) {
        super.init()
        
        if let respValue = response.id {
            self.id       = respValue
        }
        
        if let respValue = response.fields["userName"] as? String {
            self.userName  = respValue
        }
        
        if let respValue = response.fields["portfolioTotalValue"] as? Double {
            self.totalValue  = respValue
        }
        
        if let respValue = response.userID {
            self.userID  = respValue
        }
    }
    
}
