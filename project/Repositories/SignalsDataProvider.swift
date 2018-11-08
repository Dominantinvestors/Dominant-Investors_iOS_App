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
    
    func create(for company: Company,
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
    
    func search(by text: String, completion: @escaping ([SearchAssetModel]?, String?) -> Void) {
        send(request: CompanyModel.search(by: text)).responseObject { (response: DataResponse<OffsetResponse<SearchAssetModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func delete(_ signal: SignalModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: signal.delete()).response { response in
            if response.response?.statusCode == 204 {
                completion(true, nil)
            } else {
                completion(false, response.error!.localizedDescription)
            }
        }
    }
}
