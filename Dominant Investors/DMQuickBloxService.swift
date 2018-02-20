//
//  DMQuickBloxService.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import Quickblox


struct usersOld : Codable {
    
    var userID : Int
    var login  : String
    var email  : String
    
    enum CodingKeys : String, CodingKey {
        case userID = "ID"
        case login  = "login"
        case email  = "email"
    }
}

struct myarray : Codable {
    let myarray : [usersOld]
}

  

class DMQuickBloxService: NSObject {

    static let sharedInstance = DMQuickBloxService()
    static let limit = NSMutableDictionary(dictionary: ["limit" : "1000"])
    static let ratingLimit   = NSMutableDictionary(dictionary: ["limit" : "100" , "sort_desc" : "portfolioTotalValue"])
    
    private func personalLimit() -> NSMutableDictionary {
        let personalLimit = NSMutableDictionary.init(dictionary: ["count" : 1000, "limit" : 990, "parentID" : "\(DMAuthorizationManager.sharedInstance.userID)"])
        return personalLimit
    }
    
    // MARK: Get Data

    open func getPersonalPortfolio(completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        
        QBRequest.objects(withClassName: "personal2", extendedRequest: self.personalLimit(), successBlock: { (response, objects, page) in
            var personal = [DMPersonalPortfolioModel]()
            for object in objects! {
                let model = DMPersonalPortfolioModel.init(response: DMResponseObject.init(customObject: object))
                //if (model.userID == DMAuthorizationManager.sharedInstance.userProfile.userID) {
                    personal.append(model)
                //}
            }
            completion(personal.reversed())
        }) { (error) in
            completion([DMPersonalPortfolioModel]())
        }
        
    }
    
    open func getDominantPortfolio(completion : @escaping ([DMDominantPortfolioModel]) -> Void) {
        
        QBRequest.objects(withClassName: "dominantPortfolio", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            var dominant = [DMDominantPortfolioModel]()
            for object in objects! {
                dominant.append(DMDominantPortfolioModel.init(response:  DMResponseObject.init(customObject: object)))
            }
            completion(dominant)
        }) { (error) in
            completion([DMDominantPortfolioModel]())
        }
    }
    
    open func getSignalsHistory(completion : @escaping ([DMSignalHistoryModel]) -> Void) {
        
        QBRequest.objects(withClassName: "signalsHistory", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            var dominant = [DMSignalHistoryModel]()
            for object in objects! {
                dominant.append(DMSignalHistoryModel.init(response:  DMResponseObject.init(customObject: object)))
            }
            completion(dominant)
        }) { (error) in
            completion([DMSignalHistoryModel]())
        }
    }
    
    open func getUserRatings(completion : @escaping ([DMRatingModel]) -> Void) {
        QBRequest.objects(withClassName: "userPortfolioTotal", extendedRequest: DMQuickBloxService.ratingLimit, successBlock: { (response, objects, page) in
            var ratings = [DMRatingModel]()
            for object in objects! {
                ratings.append(DMRatingModel.init(response: DMResponseObject.init(customObject: object)))
            }
            completion(ratings)
        }) { (error) in
            completion([DMRatingModel]())
        }
    }
    
    open func getAnalyticsCompanies(completion : @escaping ([DMCompanyModel]) -> Void) {
        QBRequest.objects(withClassName: "CompaniesSignals", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            var companies = [DMCompanyModel]()
            for object in objects! {
                companies.append(DMCompanyModel.init(response: DMResponseObject.init(customObject: object)))
            }
            completion(companies)
        }) { (error) in
            completion([DMCompanyModel]())
        }
    }
    
    open func getInvestmentSignals(completion : @escaping ([DMInvestmentSignalModel]) -> Void) {
        QBRequest.objects(withClassName: "InvestmentIdea", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            var signals = [DMInvestmentSignalModel]()
            for object in objects! {
                signals.append(DMInvestmentSignalModel.init(response: DMResponseObject.init(customObject: object)))
            }
            completion(signals)
        }) { (error) in
            completion([DMInvestmentSignalModel]())
        }
    }
    
    open func regUser() {
        
//        if let filepath = Bundle.main.path(forResource: "USERS.JAN.BD", ofType: "json") {
//            do {
//                let contents = try String(contentsOfFile: filepath)
//                
//                let jsonData = contents.data(using: .utf8)!
//                let decoder = JSONDecoder()
//                let models = try! decoder.decode(myarray.self, from: jsonData)
//                
//                
//                var i = 1300 //START
//                
//                while i < models.myarray.count { //END
//                    let oldUser = models.myarray[i]
//                    
//                    let user = QBUUser.init()
//                    user.externalUserID = UInt(oldUser.userID)
//                    user.login = oldUser.login
//                    user.email = oldUser.email
//                    user.password = "weaDF3mz"
//                    
//                    QBRequest.signUp(user, successBlock: { (response, user) in
//                        print("")
//                    }) { (error) in
//                        print("")
//                    }
//                    
//                    i += 1
//                }
//
//                print("")
//                
//                
//            } catch {
//                // contents could not be loaded
//                print("could not be loaded")
//            }
//            
//        } else {
//            
//        }
       
      
        
    }
    
    // MARK: Set Data
    
    open func addNew(personalStock : DMPersonalPortfolioModel, completion : @escaping ([DMPersonalPortfolioModel]?, String?) -> Void) {
        
        SwiftStockKit.fetchDataForStocks(symbols: [personalStock.ticker!]) { (chartPoints) in
          
            guard let valuePriceValue = chartPoints[personalStock.ticker!]?.close else {
                completion(nil, "Sorry, price for this ticker now is unavailable".localized)
                return
            }
            
            let valuePrice = Double(valuePriceValue)
            let quickbloxStock = QBCOCustomObject()
            quickbloxStock.className = "personal2"
            quickbloxStock.fields!.setObject(DMAuthorizationManager.sharedInstance.userID, forKey: "parentID" as NSCopying)
            quickbloxStock.fields!.setObject(personalStock.ticker!, forKey: "ticker" as NSCopying)
            quickbloxStock.fields!.setObject(DMDateService.sharedInstance.dominantStringFrom(date: Date()), forKey: "crt_at" as NSCopying)
            quickbloxStock.fields!.setObject(String(format: "%.2f", valuePrice), forKey: "entry_price" as NSCopying)
            
            QBRequest.createObject(quickbloxStock, successBlock: { (response, object) in
                if (object != nil) {
                    completion([DMPersonalPortfolioModel.init(response: DMResponseObject.init(customObject: object!))], nil)
                }
            }) { (error) in
                completion(nil, error.error.debugDescription)
            }
        }
    }
    
    open func clearPortfolio(IDs : [String], completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        QBRequest.deleteObjects(withIDs: IDs, className: "personal2", successBlock: { (response, array, array2, array3) in
            completion([DMPersonalPortfolioModel]())
        }) { (error) in
            completion([DMPersonalPortfolioModel]())
        }
    }
    
    open func deletePersonalStock(ID : String, completion : @escaping ([DMPersonalPortfolioModel]) -> Void) {
        QBRequest.deleteObject(withID: ID, className: "personal2", successBlock: { (response) in
            completion([DMPersonalPortfolioModel]())
        }) { (error) in
            completion([DMPersonalPortfolioModel]())
        }
    }
    
//    open func loginWith(login : String, password : String, competion : @escaping (Bool, String?) -> Void) {
//        QBRequest.logIn(withUserLogin: login, password: "weaDF3mz", successBlock: { (response, user) in
//            let userModel = DMUserProfileModel.init(response: DMResponseObject.init(user: user!))
//
//            if let external = user!.externalUserID as? UInt {
//                DMAuthorizationManager.sharedInstance.userID = user!.externalUserID
//            } else {
//                DMAuthorizationManager.sharedInstance.userID = user!.id
//
//                let params = QBUpdateUserParameters()
//                    params.externalUserID = user?.id
//
//                    QBRequest.updateCurrentUser(params, successBlock: { (response, user) in
//
//                    }, errorBlock: { (error) in
//                        completion(false, Strings.DMStandartSignUpError)
//                    })
//            }
//
//
//
//            DMAuthorizationManager.sharedInstance.userProfile = userModel
//            let data  = NSKeyedArchiver.archivedData(withRootObject: userModel)
//            UserDefaults.standard.set(data, forKey : "Authorized")
//            UserDefaults.standard.set(DMAuthorizationManager.sharedInstance.userID, forKey : "user_id")
//            competion(true, nil)
//        }) { (error) in
//            competion(false, Strings.DMStandartLoginError)
//        }
//    }
    
    open func loginWith(login : String, password : String, competion : @escaping (Bool, String?) -> Void) {
        QBRequest.logIn(withUserLogin: login, password: "weaDF3mz", successBlock: { (response, user) in
            let userModel = DMUserProfileModel.init(response: DMResponseObject.init(user: user!))
            
            if  user!.externalUserID != 0 {
                DMAuthorizationManager.sharedInstance.userID = user!.externalUserID
                DMAuthorizationManager.sharedInstance.userProfile = userModel
                let data  = NSKeyedArchiver.archivedData(withRootObject: userModel)
                UserDefaults.standard.set(data, forKey : "Authorized")
                UserDefaults.standard.set(DMAuthorizationManager.sharedInstance.userID, forKey : "user_id")
                competion(true, nil)
            } else {
                DMAuthorizationManager.sharedInstance.userID = user!.id
                DMAuthorizationManager.sharedInstance.userProfile = userModel
                let data  = NSKeyedArchiver.archivedData(withRootObject: userModel)
                UserDefaults.standard.set(data, forKey : "Authorized")
                UserDefaults.standard.set(DMAuthorizationManager.sharedInstance.userID, forKey : "user_id")
                
                let params = QBUpdateUserParameters()
                params.externalUserID = user!.id
                QBRequest.updateCurrentUser(params, successBlock: { (response, user) in
                    competion(true, nil)
                }, errorBlock: { (error) in
                    competion(false, Strings.DMStandartLoginError)
                })
            }
            
        }) { (error) in
            competion(false, Strings.DMStandartLoginError)
        }
    }
    
    open func signUpWith(login : String, email : String, password : String, confirm : String , inviterID : String?, completion : @escaping (Bool, String?) -> Void) {
       
        let newUser = QBUUser()
        newUser.login = login
        newUser.password = "weaDF3mz"
        newUser.email = email
        
        if let inviter = inviterID {
            newUser.customData = String(format : "Inviter ID %d", inviter)
        }
        
        QBRequest.signUp(newUser, successBlock: { (response, user) in
            completion(true, nil)
        }, errorBlock: { (responseError) in
            completion(false, Strings.DMStandartSignUpError)
        })
    }
    
    open func signOut() {
        QBRequest.logOut(successBlock: nil, errorBlock: nil)
    }
    
    open func downloadCompanyImageWith(ID : String, completion : @escaping (UIImage, String) -> Void) {
       QBRequest.downloadFile(fromClassName: "Company", objectID: ID, fileFieldName: "companyPictureURLonQuickblox", successBlock: { (response, imageData) in
                    guard let data = imageData else { self.downloadCompanyImageWith(ID: ID, completion: completion)
                        return }
                    guard let image = UIImage(data : data) else { self.downloadCompanyImageWith(ID: ID, completion: completion)
                        return }
        
            completion(image, ID)
        }, statusBlock: { (request, status) in
            
        }) { (errorResponse) in
                    self.downloadCompanyImageWith(ID: ID, completion: completion)
        }
        
    }
    
    open func downloadCompanyLogoWith(ID : String, completion : @escaping (UIImage) -> Void) {
    
        QBRequest.downloadFile(fromClassName: "Company", objectID: ID, fileFieldName: "companyLogoImage", successBlock: { (response, imageData) in
            guard let data   = imageData else { return }
            guard UIImage(data : data) != nil else { return }
            completion(UIImage(data : data)!)
        }, statusBlock: { (request, status) in
            
        }) { (errorResponse) in
            print(errorResponse.error.debugDescription)
        }
    }
    
    
    open func updateUserRating(value : Double) {
        DMAPIService.sharedInstance.getUserRatings { (ratings) in
            for rate in ratings {
                let name = rate.userName?.lowercased()
                if (rate.userID == DMAuthorizationManager.sharedInstance.userProfile.userID
                ||  name == DMAuthorizationManager.sharedInstance.userProfile.userName.lowercased()) {
                    self.updateExistRating(id: rate.id!, value: value)
                    return
                }
            }
            self.recordUserRating(value: value)
        }
    }
    
    open func checkSubscription(completion : @escaping (DMSubscriptionModel?) -> Void) {
        QBRequest.objects(withClassName: "SignalsBuyingDate", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            for userDate in objects! {
                        let name = userDate.fields["name"] as! String
                        if (name == DMAuthorizationManager.sharedInstance.userProfile.userName && String(userDate.userID) == DMAuthorizationManager.sharedInstance.userProfile.userID) {
                        let currentSubscription = DMSubscriptionModel.init(response: DMResponseObject(customObject: userDate))
                            completion(currentSubscription)
                        return
                }
            }
            completion(nil)
        }) { (error) in
            completion(nil)
        }
    }
    
    open func successPurchaseWith(expired_date : Date, completion : @escaping (Bool) -> Void) {
        self.checkSubscription { (subscription) in
            if (subscription != nil) {
                subscription?.expired_date = expired_date
                self.updateSubscription(subscription: subscription!, completion : completion)
            } else {
                self.recordNewSubscription(date : expired_date, completion : completion)
            }
        }
    }
    
    open func addInviterRecord(inviterID : String, email : String, completion : @escaping (Bool) -> Void) {
    
        let quickbloxStock = QBCOCustomObject()
        quickbloxStock.className = "inviteTable"
        quickbloxStock.fields!.setObject(inviterID, forKey: "InviterID" as NSCopying)
        quickbloxStock.fields!.setObject(email, forKey: "UserEmail" as NSCopying)
    
        QBRequest.createObject(quickbloxStock, successBlock: { (response, object) in
            // TODO : Handler
            print("")
        }) { (error) in
            // TODO : Handler
            print("error")
        }
    }
    
    
    open func getUsersList() {
        QBRequest.users(for: QBGeneralResponsePage.init(currentPage: 10, perPage: 100), successBlock: { (response, page, users) in
            
            var dict : [String] = [""]
            for user in users! {
                if let userMail = user.email {
                   dict.append(userMail)
                }
            }
            print("")
            
        }) { (error) in
            
        }
    }
    
    
    // MARK: Private
    
    private func updateSubscription(subscription : DMSubscriptionModel, completion : @escaping (Bool) -> Void) {
        
        let quickblox = QBCOCustomObject()
        quickblox.className = "SignalsBuyingDate"
        quickblox.fields!.setObject(subscription.expired_date ?? Date(), forKey: "expiredDate" as NSCopying)
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey: "name" as NSCopying)
        quickblox.id = subscription.id
        
        QBRequest.update(quickblox, successBlock: { (response, object) in
            completion(true)
        }) { (error) in
            completion(false)
        }
    }
    
    private func recordNewSubscription(date : Date, completion : @escaping (Bool) -> Void) {
        
        let quickblox = QBCOCustomObject()
        quickblox.className = "SignalsBuyingDate"
        quickblox.fields!.setObject(date, forKey: "expiredDate" as NSCopying)
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey: "name" as NSCopying)
        
        QBRequest.createObject(quickblox, successBlock: { (response, object) in
            completion(true)
        }) { (response) in
            completion(false)
        }
    }
    
    private func updateExistRating(id: String, value : Double) {
        let quickblox = QBCOCustomObject()
        
        quickblox.className = "userPortfolioTotal"
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userID, forKey: "userID" as NSCopying)
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey:"userName" as NSCopying)
        quickblox.fields!.setObject("test@mail.com", forKey: "userMail" as NSCopying)
        quickblox.fields!.setObject(value, forKey: "portfolioTotalValue" as NSCopying)
        quickblox.id = id
        
        QBRequest.update(quickblox, successBlock: { (response, object) in
            print(response.description)
        }) { (error) in
            print(error.description)
        }
    }
    
    private func recordUserRating(value : Double) {
        
        let quickblox = QBCOCustomObject()
        quickblox.className = "userPortfolioTotal"
        
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userID, forKey: "userID" as NSCopying)
        quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey:"userName" as NSCopying)
        quickblox.fields!.setObject("test@mail.com", forKey: "userMail" as NSCopying)
        quickblox.fields!.setObject(value, forKey: "portfolioTotalValue" as NSCopying)
        
        QBRequest.createObject(quickblox, successBlock: { (response, object) in
            print(response.description)
        }) { (response) in
            print(response.error?.error?.localizedDescription ?? "")
        }
    }
    

    
    
    //MARK: Trial Period Calls
    
    open func getTrialObject(completion : @escaping (DMTrialModel?) -> Void) {
        QBRequest.objects(withClassName: "Trial", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            for object in objects! {
                if let name = object.fields.object(forKey: "name") as? String {
                    if name == DMAuthorizationManager.sharedInstance.userProfile.userName {
                        completion(DMTrialModel.init(response: DMResponseObject.init(customObject: object)))
                        return
                    }
                }
            }
            completion(nil)
        }) { (error) in
            completion(nil)
        }
    }
    
    open func startTrialPeriod(date : Date, completion : @escaping (DMTrialModel?) -> Void) {
       
        self.getTrialObject { (trialObject) in
            if trialObject != nil {
                completion(trialObject)
                return
            } else {
                let quickblox = QBCOCustomObject()
                quickblox.className = "Trial"
                quickblox.fields!.setObject(date, forKey: "trialStarted" as NSCopying)
                quickblox.fields!.setObject(false, forKey: "trialBuyed" as NSCopying)
                quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey: "name" as NSCopying)
                quickblox.fields!.setObject(UIDevice.current.identifierForVendor!.uuidString, forKey: "deviceUDID" as NSCopying)
                QBRequest.createObject(quickblox, successBlock: { (response, object) in
                    print("SUCCESS")
                    completion(DMTrialModel.init(response: DMResponseObject.init(customObject: object!)))
                }) { (error) in
                    print("ERROR")
                    completion(nil)
                }
            }
        }

    }
    
    open func checkTrialPeriodStartedExpired(userName : String, completion : @escaping ([DMTrialModel]?) -> Void) {
        QBRequest.objects(withClassName: "Trial", extendedRequest: DMQuickBloxService.limit, successBlock: { (response, objects, page) in
            var array = [DMTrialModel]()
            for object in objects! {
                array.append(DMTrialModel.init(response: DMResponseObject.init(customObject: object)))
            }
            completion(array)
        }) { (error) in
            completion(nil)
        }
    }
    
    open func trialBuyed() {
        self.getTrialObject { (trialObject) in
            if trialObject != nil {
                let quickblox = QBCOCustomObject()
                quickblox.className = "Trial"
                quickblox.fields!.setObject(trialObject?.trialStarted as Any, forKey: "trialStarted" as NSCopying)
                quickblox.fields!.setObject(true, forKey: "trialBuyed" as NSCopying)
                quickblox.fields!.setObject(DMAuthorizationManager.sharedInstance.userProfile.userName, forKey: "name" as NSCopying)
                quickblox.fields!.setObject(UIDevice.current.identifierForVendor!.uuidString, forKey: "deviceUDID" as NSCopying)
                quickblox.id = trialObject?.id
                QBRequest.update(quickblox, successBlock: { (response, object) in
                    print("SUCCESS")
                    
                }, errorBlock: { (error) in
                    print("ERROR")
                })
            }
        }
    }
    
}
