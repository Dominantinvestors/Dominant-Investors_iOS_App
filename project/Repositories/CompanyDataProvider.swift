import Alamofire
import PromiseKit
struct CompanyDataProvider: PromiseRepository, Syncable {
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
    
    func get(by ID: Int) -> Promise<CompanyModel> {
        return send(request: CompanyModel.get(ID))
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
    
    func rate(_ company: Company) -> Promise<Rate> {
        return send(request: company.rate())
    }
    
    func more(_ company: Company, completion: @escaping (Widget?, String?) -> Void) {
        send(request: company.stockInfo(false)).responseObject { (response: DataResponse<Widget>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func chart(_ company: Company, completion: @escaping (Widget?, String?) -> Void) {
        send(request: company.stockInfo(true)).responseObject { (response: DataResponse<Widget>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func comments(_ company: CompanyModel, completion: @escaping ([Message]?, String?) -> Void) {
        send(request: company.comments()).responseObject { (response: DataResponse<OffsetResponse<Message>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func add(_ comment: String, _ company: CompanyModel, completion: @escaping (Message?, String?) -> Void) {
        send(request: company.add(comment)).responseObject { (response: DataResponse<
        Message>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
