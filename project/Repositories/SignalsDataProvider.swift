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
        send(request: CompanyModel.get()).responseObject { (response: DataResponse<OffsetResponse<CompanyModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addCompany(_ company: CompanyModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: company.add()).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func createSignal(for company: CompanyModel,
                      _ buyPoint: String,
                      _ targetPrice: String,
                      _ stopLoss: String,
                      completion: @escaping (Bool, String?) -> Void)
    {
        send(request: company.createSignal(buyPoint, targetPrice, stopLoss)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func search(by text: String, completion: @escaping ([CompanyModel]?, String?) -> Void) {
        send(request: CompanyModel.search(by: text)).responseObject { (response: DataResponse<OffsetResponse<CompanyModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func buy(_ amount: String, _ asset: AssetsModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: PortfolioModel.buy(amount, asset)).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
