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
    static let Currency = "$"

}

struct Fonts {
    static let DMMyseoFont : UIFont = UIFont(name: "MuseoCyrl-100", size: 11)!
    
    static func regular(_ size: CGFloat = 11) -> UIFont {
        return UIFont(name: "MuseoCyrl-300", size: size)!
    }
    
    static func bolt(_ size: CGFloat = 11) -> UIFont {
        return UIFont(name: "MuseoCyrl-300", size: size)!
    }
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

struct Network {
    
    static let baseURL2 = "https://dominant-investors.geeks.land/api/v1"
    
    static let baseURL = "http://172.104.22.205"
    static let APIVersion = "/api/v1"
    static let authAPIModule = "/accounts"
    static let loginEndPoint = "/login/"
    static let logoutEndPoint = "/logout/"
	static let main = "/main/"
//    http://172.104.22.205/api/v1/accounts/login/
}

struct ConstantsUserDefaults{
	static let authorized = "Authorized"
	static let accessToken = "AccessToken"
}


