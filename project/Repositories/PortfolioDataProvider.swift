import Alamofire
import PromiseKit

struct PortfolioDataProvider: PromiseRepository, Syncable {
    
    typealias Item = PortfolioModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> PortfolioDataProvider {
        let session: MainSessionManager = ServiceLocator.shared.getService()
        return PortfolioDataProvider(session: session, handler: BaseHandler())
    }
    
    func get() -> Promise<PortfolioModel> {
        return send(request: PortfolioModel.get())
    }
    
    func transactions() -> Promise<OffsetResponse<TransactionModel>> {
        return send(request: PortfolioModel.transactions())
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
