import Alamofire
import AlamofireObjectMapper

public typealias Completion = (Int, String?) -> Void

struct AccountsDataProvider: Repository, Syncable {
    
    typealias Item = DMUserProfileModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> AccountsDataProvider {
        return AccountsDataProvider(session: SessionManager.default, handler: BaseHandler())
    }
    
    func login(_ email: String, _ password: String, completion: @escaping Completion)  {
        send(request: DMUserProfileModel.login(email, password)).responseJSON { response in
            if let json = response.result.value as? [String : AnyObject] {
                let token = json["token"] as? String
                UserDefaults.standard.set(token, forKey: ConstantsUserDefaults.accessToken)
            }
            completion(response.response?.statusCode ?? 500, response.error?.localizedDescription)
        }
    }
    
    func signOn(login: String,
                email: String,
                password: String,
                confirm: String,
                inviterID: String?,
                completion: @escaping Completion) {
        send(request: DMUserProfileModel.login(email, password)).responseJSON { response in
            if let json = response.result.value as? [String : AnyObject] {
                let token = json["token"] as? String
                UserDefaults.standard.set(token, forKey: ConstantsUserDefaults.accessToken)
            }
            completion(response.response?.statusCode ?? 500, response.error?.localizedDescription)
        }
    }
}
