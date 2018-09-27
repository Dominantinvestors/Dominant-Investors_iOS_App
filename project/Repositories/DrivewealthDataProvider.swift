import Alamofire
import ObjectMapper

struct DrivewealthDataProvider: Repository, Syncable {
    
    typealias Item = DrivewealthModel
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> DrivewealthDataProvider {
        let session: MainSessionManager = MainSessionManager.default(sessionToken: "7aac2a36-569a-4179-9a7f-8de82797a01a.2018-09-27T07:03:54.408Z")
        return DrivewealthDataProvider(session: session, handler: BaseHandler())
    }
    
    func search(by text: String, completion: @escaping ([DrivewealthModel]?, String?) -> Void) {
        send(request: DrivewealthModel.search(by: text)).responseArray { (response: DataResponse<[DrivewealthModel]>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}


extension DrivewealthModel {
    static func search(by text: String) -> RequestProvider {
        let parameters: [String: Any] = ["symbol": text]
        return URLEncodingRequestBuilder(url: "http://api.drivewealth.io/v1/instruments", method: .get, parameters: parameters)
    }
}

class DrivewealthModel: Mappable, Company {
    
    var id: String = ""
    
    var name: String = ""
    var buyPoint: String = ""
    var ticker: String = ""
    var type: String = "s"
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["instrumentID"]
        name <- map["name"]
        
        if let point = map.JSON["rateAsk"] {
            buyPoint = "\(point)"
        }
        
        ticker <- map["symbol"]
    }
}

protocol Company {
    var name: String { get }
    var buyPoint: String { get }
    var ticker: String { get }
    var type: String { get }
}

extension Company {
    func createSignal(_ buyPoint: String, _ targetPrice: String, _ stopLoss: String) -> RequestProvider {
        let parameters: [String: Any] = ["asset_type": type,
                                         "ticker": ticker,
                                         "buy_point": buyPoint,
                                         "target_price": targetPrice,
                                         "stop_loss": stopLoss]
        return JSONEncodingRequestBuilder(path: "/signals/", method: .post, parameters: parameters)
    }
}
