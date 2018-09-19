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
    @IBOutlet weak var compRating   : UILabel!
    @IBOutlet weak var epsRating    : UILabel!
    @IBOutlet weak var groupRating  : UILabel!
    @IBOutlet weak var rsRating     : UILabel!

    @IBOutlet weak var marketCapTitle    : UILabel!
    @IBOutlet weak var epsfq3Title       : UILabel!
    @IBOutlet weak var salesfq3Title     : UILabel!
    @IBOutlet weak var peRatioTitle      : UILabel!
    @IBOutlet weak var compRatingTitle   : UILabel!
    @IBOutlet weak var epsRatingTitle    : UILabel!
    @IBOutlet weak var groupRatingTitle  : UILabel!
    @IBOutlet weak var rsRatingTitle     : UILabel!

    @IBOutlet weak var lastStatus     : UIView!
    @IBOutlet weak var lastRating     : UIView!

    open func setupWithCompany(company : CompanyModel) {
        
        if !company.isCrypto() {
            
            if let stats = company.stats {
                marketCap.text = "\(stats.marketCap) Bil"
                epsfq3.text =  "\(stats.epsFQ3V) (\(stats.epsFQ3P)%)"
                peRatio.text =  String(stats.peRatio)
                salesfq3.text =  "\(stats.salesFQ3V) (\(stats.salesFQ3P)%)"
            }
            
            if let ratings = company.ratings {
               compRating.text = "\(ratings.comp) of 99"
                epsRating.text = "\(ratings.eps) of 99"
                groupRating.text = "\(ratings.group) of 99"
                rsRating.text = "\(ratings.rs) of 99"
            }
            
            marketCapTitle.text = NSLocalizedString("Market Cap", comment: "")
            epsfq3Title.text = NSLocalizedString("EPS FQ3", comment: "")
            salesfq3Title.text = NSLocalizedString("Sales FQ3", comment: "")
            peRatioTitle.text = NSLocalizedString("P/E Ratio", comment: "")
            compRatingTitle.text = NSLocalizedString("Comp Rating", comment: "")
            epsRatingTitle.text = NSLocalizedString("EPS Rating", comment: "")
            groupRatingTitle.text = NSLocalizedString("Group Rat.", comment: "")
            rsRatingTitle.text = NSLocalizedString("RS Rating", comment: "")
            
            lastStatus.isHidden = false
            lastRating.isHidden = false
        } else {
            
            if let stats = company.stats {
                marketCap.text =  "\(stats.marketCap) Bil"
                epsfq3.text =  "\(stats.circulating) Mil"
                salesfq3.text =  "\(stats.maxSupply) Mil"
            }
            
            if let ratings = company.ratings {
                compRating.text = "\(ratings.technology) of 99"
                epsRating.text = "\(ratings.command) of 99"
                groupRating.text = "\(ratings.realization) of 99"
            }
            
            marketCapTitle.text = NSLocalizedString("Market Cap", comment: "")
            epsfq3Title.text = NSLocalizedString("Sirculation", comment: "")
            salesfq3Title.text = NSLocalizedString("Max Supply", comment: "")
            compRatingTitle.text = NSLocalizedString("Technology", comment: "")
            epsRatingTitle.text = NSLocalizedString("Command", comment: "")
            groupRatingTitle.text = NSLocalizedString("Realisation", comment: "")
            
            lastStatus.isHidden = true
            lastRating.isHidden = true
        }
    }
}
