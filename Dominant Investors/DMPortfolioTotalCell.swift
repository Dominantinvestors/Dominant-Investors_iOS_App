//
//  DMPortfolioTotalCell.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMPortfolioTotalCell: UITableViewCell {

    @IBOutlet weak var totalLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = self.contentView.backgroundColor;
    }
    
    open func setTotal(value : Double) {
        value >= 0 ? (self.totalLabel.textColor = Colors.DMProfitGreenColor) : (self.totalLabel.textColor = UIColor.red)
        self.totalLabel.text = String(format : "%.2f", value).appending("%")
    }
    
}
