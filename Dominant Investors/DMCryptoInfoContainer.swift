//
//  DMCryptoInfoContainer.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 01.12.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMCryptoInfoContainer: UIView {

    @IBOutlet weak var marketCap           : UILabel!
    @IBOutlet weak var cirulatingSupply    : UILabel!
    @IBOutlet weak var maxSupply           : UILabel!
    
    open func setupWithCompany(company : DMCompanyModel) {
        self.marketCap.text = company.MarketCap
        self.cirulatingSupply.text = company.cirulatingSupply
        self.maxSupply.text = company.maxSupply
    }

}
