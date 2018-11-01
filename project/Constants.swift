import UIKit

struct Values {
    static let Currency = "$"
}

struct Fonts {
    static func regular(_ size: CGFloat = 11) -> UIFont {
        return UIFont(name: "MuseoCyrl-300", size: size)!
    }
    
    static func bolt(_ size: CGFloat = 11) -> UIFont {
        return UIFont(name: "MuseoCyrl-500", size: size)!
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
    static let baseURL = "https://api.dominant-investors.com/api/v1"
}

struct ConstantsUserDefaults{
	static let accessToken = "AccessToken"
}


