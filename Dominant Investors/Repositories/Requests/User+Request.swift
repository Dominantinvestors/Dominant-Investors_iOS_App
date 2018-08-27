import Alamofire

fileprivate struct Key {
    static let email = "email"
    static let password = "password"
    
    static let password1 = "password1"
    static let password2 = "password2"
    static let firstName = "first_name"
    static let lastName = "last_name"
}

extension DMUserProfileModel {
    
    static func login(_ email: String, _ password: String) -> RequestProvider {
        let parameters: [String: Any] = [Key.email: email,
                                         Key.password: password]
        return URLEncodingRequestBuilder(path: "http://dominant-investors.geeks.land/api/v1/accounts/login/", method: .post, parameters: parameters)
    }
    
    static func registration(login: String,
                             email: String,
                             password: String,
                             confirm: String,
                             firstName: String,
                             lastName: String) -> RequestProvider
    {
        let parameters: [String: Any] = [Key.email: email,
                                         Key.password1: password,
                                         Key.password2: confirm,
                                         Key.firstName: firstName,
                                         Key.lastName: lastName]
        return URLEncodingRequestBuilder(path: "http://dominant-investors.geeks.land/api/v1/accounts/registration/", method: .post, parameters: parameters)
    }
    
    static func logout() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "http://dominant-investors.geeks.land/api/v1/accounts/logout/", method: .post)
    }
}
