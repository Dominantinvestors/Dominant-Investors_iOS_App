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
        send(request: DMUserProfileModel.login(email, password)).response { respounce in
            completion(respounce.response?.statusCode ?? 500, respounce.error?.localizedDescription)
        }
    }
//
//    func settings(completion: @escaping (Response<Settings>) -> Void)  {
//        let trace = Performance.startTrace(name: "GetSettings")
//        send(request: Settings.settings()).responseObject { (response: DataResponse<Settings>) -> Void in
//            trace?.stop()
//            completion(self.handler.handle(response))
//        }
//    }
//
//    func reqisterNotificationToken(_ user: User, _ token: String, completion: @escaping Completion)  {
//        let trace = Performance.startTrace(name: "ReqisterNotificationToken")
//        send(request: user.reqisterNotificationToken(token)).response { respounce in
//            trace?.stop()
//            completion(respounce.response?.statusCode ?? 500, respounce.error?.localizedDescription)
//        }
//    }
}
