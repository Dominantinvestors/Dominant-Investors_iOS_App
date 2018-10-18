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
    
    func assets(completion: @escaping ([AssetsModel]?, String?) -> Void) {
        send(request: PortfolioModel.assets()).responseObject { (response: DataResponse<OffsetResponse<AssetsModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func transactions(completion: @escaping ([AssetsModel]?, String?) -> Void) {
        send(request: PortfolioModel.transactions()).responseObject { (response: DataResponse<OffsetResponse<AssetsModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
