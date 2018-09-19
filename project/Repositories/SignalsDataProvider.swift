import Alamofire

struct SignalsDataProvider: Repository, Syncable {
    
    typealias Item = SignalModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> SignalsDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return SignalsDataProvider(session: session, handler: BaseHandler())
    }
    
    func get(completion: @escaping ([SignalModel]?, String?) -> Void) {
        send(request: SignalModel.get()).responseObject { (response: DataResponse<OffsetResponse<SignalModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func companies(completion: @escaping ([CompanyModel]?, String?) -> Void) {
        send(request: SignalModel.companies()).responseObject { (response: DataResponse<OffsetResponse<CompanyModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addCompany(_ company: Int, completion: @escaping (Bool, String?) -> Void) {
        send(request: SignalModel.addCompany(company)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
