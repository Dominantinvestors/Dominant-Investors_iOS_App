//
//  DMPortfolioUserInterface.swift
//  Dominant Investors
//
//  Created by Nekit on 25.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

protocol DMPortfolioUserInterface {
    func reloadData()
    func showError(message : String)
    
    func showStockDetail(controller : DMStockDetailViewController)
    func showStockChart(vc : DMTradingViewChartViewController)
    func didReloaded()
}
