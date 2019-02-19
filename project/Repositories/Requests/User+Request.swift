import Alamofire

fileprivate struct Key {
    static let email = "email"
    static let password = "password"
    static let username = "username"

    static let password1 = "password1"
    static let password2 = "password2"
    static let firstName = "first_name"
    static let lastName = "last_name"
}

extension UserModel {
    
    static func login(_ email: String, _ password: String) -> RequestProvider {
        let parameters: [String: Any] = [Key.email: email,
                                         Key.password: password]
        return JSONEncodingRequestBuilder(path: "/accounts/login/", method: .post, parameters: parameters)
    }
    
    static func registration(_ email: String,
                             _ password: String,
                             _ confirm: String,
                             _ firstName: String,
                             _ lastName: String) -> RequestProvider
    {
        let parameters: [String: Any] = [Key.email: email,
                                         Key.password1: password,
                                         Key.password2: confirm,
                                         Key.firstName: firstName,
                                         Key.lastName: lastName]
        return JSONEncodingRequestBuilder(path: "/accounts/registration/", method: .post, parameters: parameters)
    }
    
    static func logout() -> RequestProvider {
        return JSONEncodingRequestBuilder(path: "/accounts/logout/", method: .post)
    }
    
    static func user() -> RequestProvider {
        return JSONEncodingRequestBuilder(path: "/accounts/user/", method: .get)
    }
    
    static func registerFDT(_ token: String) -> RequestProvider {
        let parameters: [String: Any] = ["registration_id": token,
                                         "active": true]
        return JSONEncodingRequestBuilder(path: "/device/fcm/", method: .post, parameters: parameters)
    }
}

