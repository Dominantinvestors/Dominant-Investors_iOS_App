import Alamofire

fileprivate struct Key {
    static let email = "email"
    static let password = "password"
//    static let clientSecret = "clientsecret"
//    static let shopid = "shopid"
//    static let notificationstoken = "notificationstoken"
}
//
//extension User {
//
//    static func authorise(_ email: String, _ password: String) -> RequestProvider {
//        let parameters: [String: Any] = [Key.userName: email,
//                                         Key.password: password,
//                                         Key.clientSecret: Environment.clientSecret,
//                                         Key.shopid: Environment.shopid]
//
//        return URLEncodingRequestBuilder(path: Environment.validateuser, method: .post, parameters: parameters)
//    }
//
//    func welcomePageRequest(with path: String ) -> RequestProvider {
//        let parameters: [String: Any] = [Key.userName: email,
//                                         Key.password: password,
//                                         Key.clientSecret: Environment.clientSecret,
//                                         Key.shopid: Environment.shopid]
//
//        return URLEncodingRequestBuilder(path: path, method: .post, parameters: parameters)
//    }
//
//    func reqisterNotificationToken(_ token: String) -> RequestProvider {
//        let parameters: [String: Any] = [Key.userName: email,
//                                         Key.password: password,
//                                         Key.clientSecret: Environment.clientSecret,
//                                         Key.shopid: Environment.shopid,
//                                         Key.notificationstoken: token]
//
//        return URLEncodingRequestBuilder(path: Environment.registerNotification, method: .post, parameters: parameters)
//    }
//}

extension DMUserProfileModel {
    
    static func login(_ email: String, _ password: String) -> RequestProvider {
        
        let parameters: [String: Any] = [Key.email: email,
                                         Key.password: password]
        return URLEncodingRequestBuilder(path: "http://dominant-investors.geeks.land/api/v1/accounts/login/", method: .post, parameters: parameters)
    }
}
