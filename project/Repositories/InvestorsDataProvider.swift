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
}

