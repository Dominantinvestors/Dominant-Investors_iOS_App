//
//  DMStatsContainer.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 01.12.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMStatsContainer: UIView {

    @IBOutlet weak var marketCap    : UILabel!
    @IBOutlet weak var epsfq3       : UILabel!
    @IBOutlet weak var salesfq3     : UILabel!
    @IBOutlet weak var peRatio      : UILabel!
    @IBOutlet weak var epsRating    : UILabel!
    @IBOutlet weak var groupRating  : UILabel!
    
 
    open func setupWithCompany(company : DMCompanyModel) {
        self.marketCap.text = company.MarketCap
        self.epsfq3.text = company.EPS_FQ3
        self.salesfq3.text = company.Sales_FQ3
        self.peRatio.text = company.PE_Ratio
        self.epsRating.text = company.EPS_Rating
        self.groupRating.text = company.Group_rat
    }
}
