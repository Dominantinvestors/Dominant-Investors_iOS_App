//
//  DMCompanyModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import Quickblox

class DMCompanyModel: NSObject {
    
    
    var id                          : String!
    var ticker                      : String!
    var name                        : String!
    var companylogo                 : UIImage!
    var companyPictureURL           : UIImage!
    
    var buyPoint                    : String!
    var stopLoss                    : String!
    var targetPrice                 : String!
    var investmentHorizon           : String!
    var companyDescription          : String!
    var estimazeURL                 : URL?
    
    var estimaze_EPS_URL            : URL?
    var tradingViewTicker           : String!
    
    var EPS_Rating          : String!
    var Sales_FQ3           : String!
    var MarketCap           : String!
    var EPS_FQ3             : String!
    var PE_Ratio : String!
    var isCrypto = false
    var Group_rat : String!
    
    var cirulatingSupply : String!
    var maxSupply : String!
    
    var potentialProfitability      : String!
    
    init(response : DMResponseObject) {
        super.init()
        self.id = response.id
        
        if let fields = response.fields as? [String : Any] {
            
            self.ticker = fields["companySymbol"] as? String ?? "N/A"
            self.tradingViewTicker = fields["tradingViewTicker"] as? String ?? self.ticker!
            self.EPS_Rating = fields["EPS_Rating"] as? String ?? "N/A"
            self.Sales_FQ3 = fields["Sales_FQ3"] as? String ?? "N/A"
            self.MarketCap = fields["MarketCap"] as? String ?? "N/A"
            self.EPS_FQ3 = fields["EPS_FQ3"] as? String ?? "N/A"
            self.PE_Ratio = fields["PE_Ratio"] as? String ?? "N/A"
            self.isCrypto = fields["isCrypto"] as? Bool ?? false
            self.Group_rat = fields["Group_rat"] as? String ?? "N/A"
            self.name = fields["companyName"] as? String ?? "N/A"
            self.buyPoint = fields["buyPoint"] as? String ?? "N/A"
            self.stopLoss = fields["stopLoss"] as? String ?? "N/A"
            self.companyDescription = fields["companyDescription"] as? String ?? ""
            self.targetPrice = fields["targetPrice"] as? String ?? "N/A"
            self.investmentHorizon = fields["investmentHorizon"] as? String ?? "N/A"
            self.potentialProfitability = fields["potentialProfitability"] as? String ?? "N/A"
            self.maxSupply = fields["maxSupply"] as? String ?? "N/A"
            self.cirulatingSupply = fields["cirulatingSupply"] as? String ?? "N/A"
            
            if let estimazeURL = fields["estimazeURL"] as? String {
                self.estimazeURL = URL.init(string: estimazeURL)
            }
            
            if let urlString = fields["estimaze_EPS_URL"] as? String {
                self.estimaze_EPS_URL = URL.init(string: urlString)
            }
        }
    }
    
    
    
}
