//
//  DMPersonalPortfolioService.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMPersonalPortfolioService: NSObject, UITableViewDataSource, UITableViewDelegate, DMStockCellDelegate {

    static let sharedInstance = DMPersonalPortfolioService()
    
    var portfolios     = [DMPersonalPortfolioModel]()
    var selectedTicker : StockSearchResult?
    var userInterface  : DMPortfolioUserInterface?
    
    var totalData = [String : Double]()
    var stocksData = [String : ChartPoint]()
    var portfolioTotal  : Double = 0
    var portfolioMiddle : Double = 0
    var totalCell : DMPortfolioTotalCell?
  
    var ratingUploaded = false
    
    override init() {
        super.init()
        self.reloadEmptyData()
    }
    
    open func reloadEmptyData() {
        self.getPersonalPortfolio { (portfolios) in
            self.portfolios = portfolios
            SwiftStockKit.fetchDataForStocks(symbols: self.getStocksList(), completion: { (points) in
                DispatchQueue.main.async {
                    self.stocksData = points
                    self.userInterface?.reloadData()
                }
            })
        }
 
    }
    
    open func getPersonalPortfolio(completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getPersonalPortfolio(completion: completion)
    }
    
    open func renewPersonalData() {
        self.ratingUploaded = false
        self.getPersonalPortfolio { (portfolios) in
            self.portfolios = portfolios
            SwiftStockKit.fetchDataForStocks(symbols: self.getStocksList(), completion: { (points) in
                DispatchQueue.main.async {
                self.stocksData = points
                self.userInterface?.reloadData()
                }
            })
        }
    }
    
    open func addNew() {
        let newStock = DMPersonalPortfolioModel.init(stockSearch: self.selectedTicker!)
        self.userInterface?.didReloaded()
        
        self.addNew(personalStock: newStock) { (newPortfolios, error) in
            
            if error != nil {
                self.userInterface?.showError(message: error!)
                return
            } else if newPortfolios != nil {
            
            self.selectedTicker = nil
            self.ratingUploaded = false
            var newVarPortfolios = newPortfolios!
            newVarPortfolios.append(contentsOf: self.portfolios)
            self.portfolios = newVarPortfolios
        
            SwiftStockKit.fetchDataForStocks(symbols: self.getStocksList(), completion: { (points) in
                DispatchQueue.main.async {
                    self.stocksData = points
                    self.userInterface?.reloadData()
                }
            })
            }
        }
    }
    
    open func clearPortfolio() {
        var IDs = [String]()
        for stock in self.portfolios {
            IDs.append(stock.id!)
        }
        self.ratingUploaded = false
        self.clearPortfolio(IDs: IDs) { (portfolios) in
            self.portfolios.removeAll()
            self.stocksData.removeAll()
            self.totalData.removeAll()
            
            DispatchQueue.main.async {
                self.userInterface?.reloadData()
            }
        }
    }
    
    open func changeUser() {
        self.portfolios.removeAll()
        self.stocksData.removeAll()
        self.totalData.removeAll()
    }
    
    // MARK: Private
    
    private func clearPortfolio(IDs : [String], completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.clearPortfolio(IDs : IDs, completion: completion)
    }
    
    private func addNew(personalStock : DMPersonalPortfolioModel, completion : @escaping ([DMPersonalPortfolioModel]?, String?) -> Void) {
         DMAPIService.sharedInstance.addNew(personalStock: personalStock, completion: completion)
    }
    
    private func updateUserRating() {
        if (totalData.values.count == self.portfolios.count) {
            self.totalCell?.setTotal(value: self.portfolioMiddle)
            if (!self.ratingUploaded) {
                self.ratingUploaded = true
                DMQuickBloxService.sharedInstance.updateUserRating(value: self.portfolioMiddle)
            }
        }
    }
    
    private func moreAboutStock(stock : DMPersonalPortfolioModel) {
    let controller = UIStoryboard(name: "Portfolio", bundle: nil).instantiateViewController(withIdentifier: "DMStockDetailViewController") as! DMStockDetailViewController
//        self.userInterface?.showStockDetail(controller: controller)
        SwiftStockKit.fetchStockForSymbol(symbol: stock.ticker!) { (stock) -> () in
            DispatchQueue.main.async {
                controller.stockSymbol = stock.symbol!
                controller.stock = stock
                self.userInterface?.showStockDetail(controller: controller)
            }
        }
    }
    
    private func deletePersonalStock(stock : DMPersonalPortfolioModel) {
        self.portfolios.remove(object: stock)
        self.totalData = [String : Double]()
        DMAPIService.sharedInstance.deletePersonalStock(ID: stock.id!) { (portfolios) in
            self.ratingUploaded = false
            SwiftStockKit.fetchDataForStocks(symbols: self.getStocksList(), completion: { (points) in
                DispatchQueue.main.async {
                    self.stocksData = points
                    self.userInterface?.reloadData()
                }
            })
        }
    }
    
    private func getStocksList() -> [String] {
        var stocksArray = [String]()
        for stock in self.portfolios {
            stocksArray.append(stock.ticker!)
        }
        
        return stocksArray
    }
    
    private func showChartFor(ticker : String) {
        let storyboard = UIStoryboard.init(name: "OutsourceCharts", bundle: nil)
        if let chartVC = storyboard.instantiateViewController(withIdentifier: "DMTradingViewChartViewController") as? DMTradingViewChartViewController {
            chartVC.ticker = ticker
            self.userInterface?.showStockChart(vc: chartVC)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row == self.portfolios.count) {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
          if (indexPath.row != self.portfolios.count) {
            
            let more = UITableViewRowAction(style: .normal, title: NSLocalizedString("More".localized, comment: "")) { (action, indexPath) in
                tableView.setEditing(false, animated: true)
                self.moreAboutStock(stock: self.portfolios[indexPath.row])
            }
            more.backgroundColor = UIColor.init(red: 154/255, green: 153/255, blue: 165/255, alpha: 1)
            
            let chart = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Chart".localized, comment: "")) { (action, indexPath) in
                self.showChartFor(ticker: self.portfolios[indexPath.row].ticker!)
            }
            chart.backgroundColor = UIColor.init(red: 174/255, green: 174/255, blue: 186/255, alpha: 1)
            
            let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete".localized, comment: "")) { (action, indexPath) in
                let stock = self.portfolios[indexPath.row]
                self.deletePersonalStock(stock: stock)
                self.ratingUploaded = false
            }
            delete.backgroundColor = UIColor.init(red: 250/255, green: 30/255, blue: 29/255, alpha: 1)
       
            return [delete, more, chart]
        } else {
            return nil
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (portfolios.count != 0) {
            return portfolios.count + 1
        } else {
            return 0
        }
        self.userInterface?.didReloaded()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == portfolios.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DMPortfolioTotalCell") as! DMPortfolioTotalCell
            self.totalCell = cell
            self.userInterface?.didReloaded()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DMStockCell") as! DMStockCell
        let personalStock = portfolios[indexPath.row]
        
        if let stockData = self.stocksData[personalStock.ticker!] {
            cell.setupWithPersonal(stock: personalStock, data : stockData)
        }
        cell.delegate = self
        return cell
    }
    
    // MARK: DMStockCellDelegate
    
    func setToTotalValue(ticker : String, value : Double) {
        totalData[ticker] = value
        calculateTotal()
    }
    
    private func calculateTotal() {
        self.portfolioTotal = 0
        self.portfolioMiddle = 0
        for value in totalData.values {
            self.portfolioTotal += value
        }
        if (self.totalData.values.count != 0) {
        self.portfolioMiddle = (self.portfolioTotal / Double(self.totalData.values.count))
        }
        updateUserRating()
    }

}
