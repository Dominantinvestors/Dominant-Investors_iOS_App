import Alamofire
import AlamofireObjectMapper

public typealias Completion = (Bool, String?) -> Void

struct AccountsDataProvider: Repository, Syncable {
    
    typealias Item = UserModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> AccountsDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return AccountsDataProvider(session: session, handler: BaseHandler())
    }

    func login(_ email: String, _ password: String, completion: @escaping Completion) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        send(request: UserModel.login(email, password)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(let json):
                if let json = json as? [String : AnyObject] {
                    if let token = json["key"] as? String  {
                        UserDefaults.standard.set(token, forKey: ConstantsUserDefaults.accessToken)
                        ServiceLocator.shared.registerService(service: MainSessionManager.default(token:token))
                    }
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

        send(request: UserModel.registration(email, password, confirm, login, "non")).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(let json):
                if let json = json as? [String : AnyObject] {
                    if let token = json["key"] as? String  {
                        UserDefaults.standard.set(token, forKey: ConstantsUserDefaults.accessToken)
                        ServiceLocator.shared.registerService(service: MainSessionManager.default(token:token))
                    }
                }
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func logout(completion: @escaping Completion)  {
        send(request: UserModel.logout()).responseJSON { response in
            switch self.handler.handle(response) {
            case .success( _ ):
                UserDefaults.standard.set(nil, forKey: ConstantsUserDefaults.accessToken)
                ServiceLocator.shared.registerService(service: MainSessionManager.default())
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func getUser(completion: @escaping (UserModel?, String?) -> Void)  {
        send(request: UserModel.user()).responseObject { (response: DataResponse<Item>) -> Void in
            switch self.handler.handle(response) {
            case .success(let user):
                completion(user, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
