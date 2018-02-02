//
//  DMStockCellDelegate.swift
//  Dominant Investors
//
//  Created by Nekit on 23.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

protocol DMStockCellDelegate {
    func setToTotalValue(ticker : String, value : Double)
}
