import Alamofire

struct InvestorsDataProvider: Repository, Syncable {

    typealias Item = InvestorModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> InvestorsDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return InvestorsDataProvider(session: session, handler: BaseHandler())
    }
    
    func get(completion: @escaping ([InvestorModel]?, String?) -> Void) {
        send(request: InvestorModel.get()).responseObject { (response: DataResponse<OffsetResponse<InvestorModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func get(_ investor: InvestorModel, completion: @escaping (InvestorModel?, String?) -> Void) {
        send(request: investor.get()).responseObject { (response: DataResponse<InvestorModel>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
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

