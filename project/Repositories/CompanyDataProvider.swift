import Alamofire

struct CompanyDataProvider: Repository, Syncable {
    typealias Item = CompanyModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> CompanyDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return CompanyDataProvider(session: session, handler: BaseHandler())
    }
   
    func get(completion: @escaping ([CompanyModel]?, String?) -> Void) {
        send(request: CompanyModel.get()).responseObject { (response: DataResponse<OffsetResponse<CompanyModel>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func get(_ byID: Int, completion: @escaping (CompanyModel?, String?) -> Void) {
        send(request: CompanyModel.get(byID)).responseObject { (response: DataResponse<CompanyModel>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addToWatchList(_ company: CompanyModel, completion: @escaping (Bool, String?) -> Void) {
        send(request: company.add()).responseJSON { response in
            switch self.handler.handle(response) {
            case .success(_):
                completion(true, nil)
            case .error(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
