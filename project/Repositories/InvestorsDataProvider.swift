import Alamofire
import PromiseKit

struct InvestorsDataProvider: PromiseRepository, Syncable {

    typealias Item = InvestorModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> InvestorsDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return InvestorsDataProvider(session: session, handler: BaseHandler())
    }
    
    func get() -> Promise<OffsetResponse<InvestorModel>> {
        return send(request: InvestorModel.get())
    }
    
    func get(by id: Int) -> Promise<InvestorModel> {
        return send(request: InvestorModel.get(by: id))
    }
    
    func follow(_ investor: InvestorModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: investor.follow()).response { response in
            if response.response?.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, response.error!.localizedDescription)
            }
        }
    }
    
    func unfollow(_ investor: InvestorModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: investor.unfollow()).response { response in
            if response.response?.statusCode == 200 {
                completion(true, nil)
            } else {
                completion(false, response.error!.localizedDescription)
            }
        }
    }
}

