//
//  DMStockInfoCell.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMStockInfoCell: UICollectionViewCell {
   
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var fieldValueLbl: UILabel!
    
    func setData(data: [String : String]) {
            fieldNameLbl.text = data.keys.first
            fieldValueLbl.text = data.values.first
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
