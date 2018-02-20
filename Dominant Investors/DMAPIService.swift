//
//  DMAPIService.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMAPIService: NSObject {
    
    static let sharedInstance = DMAPIService()
    
    // MARK: Get Data
    
    open func getUserRatings(completion : @escaping ([DMRatingModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getUserRatings(completion: completion)
    }
    
    open func getPersonalPortfolio(completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getPersonalPortfolio(completion: completion)
    }
    
    open func getDominantPortfolio(completion : @escaping ([DMDominantPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getDominantPortfolio(completion: completion)
    }
    
    open func clearPortfolio(IDs : [String], completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.clearPortfolio(IDs: IDs, completion: completion)
    }
    
    open func getAnalyticsCompanies(completion : @escaping ([DMCompanyModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getAnalyticsCompanies(completion: completion)
    }
    
    open func getInvestmentSignals(completion : @escaping ([DMInvestmentSignalModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getInvestmentSignals(completion: completion)
    }
    
    open func downloadCompanyImageWith(ID : String, completion : @escaping (UIImage, String) -> Void) {
        DMQuickBloxService.sharedInstance.downloadCompanyImageWith(ID : ID, completion : completion)
    }
    
    open func downloadCompanyLogoWith(ID : String, completion : @escaping (UIImage) -> Void) {
        DMQuickBloxService.sharedInstance.downloadCompanyLogoWith(ID : ID, completion : completion)
    }
    
    open func addNew(personalStock : DMPersonalPortfolioModel, completion : @escaping ([DMPersonalPortfolioModel]?, String?) -> Void) {
        DMQuickBloxService.sharedInstance.addNew(personalStock: personalStock, completion: completion)
    }
    
    open func deletePersonalStock(ID: String, completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        DMQuickBloxService.sharedInstance.deletePersonalStock(ID: ID, completion: completion)
    }
    
    open func updateUserRating(value : Double) {
        DMQuickBloxService.sharedInstance.updateUserRating(value: value)
    }
    
    open func getSignalsHistory(completion : @escaping ([DMSignalHistoryModel]) -> Void) {
        DMQuickBloxService.sharedInstance.getSignalsHistory(completion: completion)
    }
    
    //MARK : Trial Period Calls
    
    open func startTrialPeriod(date : Date, completion : @escaping (DMTrialModel?) -> Void) {
        DMQuickBloxService.sharedInstance.startTrialPeriod(date: date, completion: completion)
    }
    
    open func checkTrialPeriodStartedExpired(userName : String, completion : @escaping ([DMTrialModel]?) -> Void) {
        DMQuickBloxService.sharedInstance.checkTrialPeriodStartedExpired(userName: userName, completion: completion)
    }
    
    open func trialBuyed() {
        DMQuickBloxService.sharedInstance.trialBuyed()
    }
    
}

