import Alamofire

public typealias Completion = (Bool, String?) -> Void

struct AccountsDataProvider: Repository, Syncable {
    
    typealias Item = UserModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> AccountsDataProvider {
        return AccountsDataProvider(session: MainSessionManager.default(token: UserDefaults.standard.string(forKey: ConstantsUserDefaults.accessToken)), handler: BaseHandler())
    }

    func login(_ email: String, _ password: String, completion: @escaping Completion) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        send(request: DMUserProfileModel.login(email, password)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(let json):
                if let json = json as? [String : AnyObject] {
                    UserDefaults.standard.set(json["key"], forKey: ConstantsUserDefaults.accessToken)
                }
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func signOn(login: String,
                email: String,
                password: String,
                confirm: String,
                completion: @escaping Completion)
    {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        send(request: DMUserProfileModel.registration(email, password, confirm, login, "non")).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(let json):
                if let json = json as? [String : AnyObject] {
                    UserDefaults.standard.set(json["key"], forKey: ConstantsUserDefaults.accessToken)
                }
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func logout(completion: @escaping Completion)  {
        send(request: DMUserProfileModel.logout()).responseJSON { response in
            switch self.handler.handle(response) {
            case .success( _ ):
                UserDefaults.standard.set(nil, forKey: ConstantsUserDefaults.accessToken)
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func getUser(completion: @escaping Completion)  {
        
        send(request: DMUserProfileModel.user()).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(let json):
                if let json = json as? [String : AnyObject] {
                    UserDefaults.standard.set(json["key"], forKey: ConstantsUserDefaults.accessToken)
                }
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
        
//        send(request: DMUserProfileModel.user()).responseObject { (response: DataResponse<UserModel>) -> Void in
//            switch self.handler.handle(response) {
//            case .success( _ ):
//                UserDefaults.standard.set(nil, forKey: ConstantsUserDefaults.accessToken)
//                completion(true, nil)
//            case .error(let error):
//                completion(false, error.localizedDescription)
//            }
//        }
    }
}



