//
//  DMCalculationService.swift
//  Dominant Investors
//
//  Created by Nekit on 23.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMCalculationService: NSObject {

    static let sharedInstance = DMCalculationService()
    
    open func calculateProfitWith(oldPrice : Double, currentPrice: Double) -> Double {
        let profit = (self.roundToPlaces(value: currentPrice, places: 2) / oldPrice * 100)
        let y = Double(round(1000*profit)/1000)
        
        return y - 100
    }
    
    func roundToPlaces(value : Double, places : Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
}
