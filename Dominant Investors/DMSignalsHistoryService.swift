//
//  DMSignalsHistoryService.swift
//  Dominant Investors
//
//  Created by Nekit on 18.06.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMSignalsHistoryService: NSObject, UITableViewDataSource, UITableViewDelegate, DMStockCellDelegate {

    static let sharedInstance = DMSignalsHistoryService()
    
    var signals = [DMSignalHistoryModel]()
    var totalData = [String : Double]()
    var portfolioTotal : Double = 0
    var portfolioMiddle : Double = 0
    var totalCell : DMPortfolioTotalCell?
    
    var userInterface : DMPortfolioUserInterface?
    
    override init() {
        super.init()
        self.getSignalsHistory { (signals) in
            self.signals = signals.reversed()
            self.userInterface?.reloadData()
        }
    }
    
    open func getSignalsHistory(completion : @escaping ([DMSignalHistoryModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getSignalsHistory(completion: completion)
    }
    
    open func refresh(completion : @escaping () -> Void) {
        self.getSignalsHistory { (signals) in
            self.signals = signals.reversed()
            self.userInterface?.reloadData()
            completion()
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if (indexPath.row == self.signals.count) {
//            return false
//        }
//        return true
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        if (tableView.cellForRow(at: indexPath) as? DMStockCell) != nil {
//            let more = UITableViewRowAction(style: .normal, title: NSLocalizedString("More", comment: "")) { (action, indexPath) in
//                tableView.setEditing(false, animated: true)
//                self.moreAboutStock(stock: self.signals[indexPath.row])
//            }
//            more.backgroundColor = UIColor.blue
//            return nil//[more]
//        } else {
//            return nil
//        }
        
        return nil
    }
    
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (signals.count != 0) {
            return signals.count //+ 1
        } else {
            self.userInterface?.didReloaded()
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if (indexPath.row == portfolios.count) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DMPortfolioTotalCell") as! DMPortfolioTotalCell
//            self.totalCell = cell
//            self.userInterface?.didReloaded()
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMStockCell") as! DMStockCell
        cell.delegate = self
        cell.setupWithHistorySignal(stock: signals[indexPath.row])
        return cell
    }
    
    // MARK: DMStockCellDelegate
    
    func setToTotalValue(ticker : String, value : Double) {
        totalData[ticker] = value
        calculateTotal()
    }
    
    // MARK: Private
    
    private func calculateTotal() {
        self.portfolioTotal = 0
        for value in totalData.values {
            self.portfolioTotal += value
        }
        self.portfolioMiddle = (self.portfolioTotal / Double(self.totalData.values.count))
        self.totalCell?.setTotal(value: self.portfolioMiddle)
    }
    
    private func moreAboutStock(stock : DMSignalHistoryModel) {
//        let controller = UIStoryboard(name: "Portfolio", bundle: nil).instantiateViewController(withIdentifier: "DMStockDetailViewController") as! DMStockDetailViewController
//        
//        SwiftStockKit.fetchStockForSymbol(symbol: stock.ticker!) { (stock) -> () in
//            DispatchQueue.main.async {
//                controller.stockSymbol = stock.symbol!
//                controller.stock = stock
//                self.userInterface?.showStockDetail(controller: controller)
//            }
//        }
    }
    
}
