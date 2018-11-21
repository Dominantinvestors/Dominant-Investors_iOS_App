import Alamofire

struct PortfolioDataProvider: Repository, Syncable {
    
    typealias Item = PortfolioModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> PortfolioDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return PortfolioDataProvider(session: session, handler: BaseHandler())
    }
    
    func get(completion: @escaping (PortfolioModel?, String?) -> Void) {
        send(request: PortfolioModel.get()).responseObject { (response: DataResponse<PortfolioModel>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func transactions(completion: @escaping ([TransactionModel]?, String?) -> Void) {
        send(request: PortfolioModel.transactions()).responseObject { (response: DataResponse<OffsetResponse<TransactionModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func transactions(_ forUser: Int, completion: @escaping ([TransactionModel]?, String?) -> Void) {
        send(request: PortfolioModel.transactions(forUser)).responseObject { (response: DataResponse<OffsetResponse<TransactionModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func buy(_ rate: String, _ amount: String, _ company: Company, completion: @escaping (Bool, String?) -> Void) {
        send(request: company.buy(rate, amount)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func sell(_ rate: String, _ amount: String, _ company: Company, completion: @escaping (Bool, String?) -> Void) {
        send(request: company.sell(rate, amount)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
