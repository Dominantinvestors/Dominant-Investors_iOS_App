//
//  StockCell.swift
//  SwiftStockExample
//
//  Created by Nekit on 5/3/15.
//  Copyright (c) 2015 Nekit. All rights reserved.
//

import UIKit

class DMStockCell: UITableViewCell {

    @IBOutlet weak var ticker             : UILabel!
    @IBOutlet weak var exchangeOrBuyPoint : UILabel!
    @IBOutlet weak var currentPrice       : UILabel!
    @IBOutlet weak var profitability      : UILabel!
    @IBOutlet weak var investmentPeriod   : UILabel!

    var delegate : DMStockCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupWithDominant(stock : DMDominantPortfolioModel) {
        
        self.ticker.text = stock.ticker
        self.exchangeOrBuyPoint.text = stock.exchange
        self.investmentPeriod.text = NSLocalizedString("(12 Month)", comment: "")
        
        SwiftStockKit.fetchChartPoints(symbol: stock.ticker!, range: .OneYear, crypto: false) { (chartPoints) in
            DispatchQueue.main.async {
                let yearAgoPrice = Double(chartPoints.first!.close!)
                let currentPrice = Double(chartPoints.last!.close!)
                self.currentPrice.text  = String(format: "%.2f", currentPrice)
                let profitability = DMCalculationService.sharedInstance.calculateProfitWith(oldPrice: yearAgoPrice, currentPrice: currentPrice)
                profitability >= 0 ? (self.profitability.textColor = Colors.DMProfitGreenColor) : (self.profitability.textColor = UIColor.red)
                self.profitability.text = String(format: "%.2f", profitability).appending("%")
                self.delegate.setToTotalValue(ticker: stock.id!, value: profitability)
            }
        }
        
    }
    
    public func setupWithPersonal(stock: DMPersonalPortfolioModel, data : ChartPoint) {
        self.ticker.text = stock.ticker
        self.exchangeOrBuyPoint.text = stock.entry_price
        self.investmentPeriod.text = DMDateService.sharedInstance.differenceBetweenDates(dateOne: stock.entry_date!, dateTwo: Date())
        
        DispatchQueue.main.async {
            var currentPrice : Double = 0
            
            if (data.close != nil) {
                currentPrice = Double(data.close!)
            }
            
            self.currentPrice.text  = String(format: "%.2f", currentPrice)
            let profitability = DMCalculationService.sharedInstance.calculateProfitWith(oldPrice: Double(stock.entry_price!)!, currentPrice: currentPrice)
            profitability >= 0 ? (self.profitability.textColor = Colors.DMProfitGreenColor) : (self.profitability.textColor = UIColor.red)
            self.profitability.text = String(format: "%.2f", profitability).appending("%")
            self.delegate.setToTotalValue(ticker: stock.id!, value: profitability)
        }
    }
    
    public func setupWithHistorySignal(stock: DMSignalHistoryModel) {
        
        self.ticker.text = stock.ticker
        self.exchangeOrBuyPoint.text = stock.buyPoint
        self.currentPrice.text = stock.sellPoint
        self.investmentPeriod.text = ""
        self.profitability.text = stock.profitability
        
        self.profitability.textColor = stock.profitly == true ? Colors.DMProfitGreenColor : UIColor.red
       
    }
    
}


