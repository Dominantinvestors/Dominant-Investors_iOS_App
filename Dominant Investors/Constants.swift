//
//  Constants.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

enum DMPortfolioType : Int {
    case DMPersonalPortfolio = 0
    //case DMDominantPortfolio = 1
    case DMSignalsHistory = 1
}

enum DMActionType : Int {
    case DMAddNewStockAction = 0
    case DMClearPortfolioAction = 1
}

struct Values {
    static let DMTabsCount     : Int = 3
    static let DMDefaultScreen : Int = 0
    static let DMPortfolioScreen : Int = 2
    
}

struct Fonts {
    static let DMMyseoFont : UIFont = UIFont(name: "MuseoCyrl-100", size: 11)!
}

struct Colors {
    static let DMProfitGreenColor = UIColor.init(red: 84/255, green: 162/255, blue: 88/255, alpha: 1)
}

struct Strings {
    static let DMStandartLoginError  = NSLocalizedString("Wrong username or password.", comment: "")
    static let DMStandartSignUpError = NSLocalizedString("Account with provided username or e-mail already exist.", comment: "")
}

struct APIReqests {
    static let DMUniqueAPIKey = "bd8faf666cb58d501e9078b4dd1bc78a"
}



