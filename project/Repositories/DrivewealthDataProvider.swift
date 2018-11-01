import Alamofire
import ObjectMapper

struct CryptoCompareDataProvider: Repository, Syncable {
    
    typealias Item = ChartPoint
    
    let session: SessionManager
    let handler: CompletionHandler
    
    static func `default`() -> CryptoCompareDataProvider {
        let session: MainSessionManager = MainSessionManager.default()
        return CryptoCompareDataProvider(session: session, handler: BaseHandler())
    }
    
    func get(for crypto: String, completion: @escaping ([ChartPoint]?, String?) -> Void) {
        
        send(request: ChartPoint.get(for: crypto)).responseObject { (response: DataResponse<CryptoCompareResponse<ChartPoint>>) -> Void in
            switch self.handler.handle(response) {
            case .success(let result):
                completion(result.items, nil)
            case .error(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}


extension ChartPoint {
    
  static  func get(for crypto: String) -> RequestProvider {
        let parameters: [String: Any] = ["fsym": crypto,
                                         "tsym": "USD",
                                         "limit": "400",
                                         "allData": "true",
                                         "e": "CCCAGG",
                                         "aggregate": "10"]
        return URLEncodingRequestBuilder(url: "https://min-api.cryptocompare.com/data/histohour", method: .get, parameters: parameters)
    }
}

class CryptoCompareResponse<T:Mappable>: Mappable {
    
    var response: String = ""
    var message: String = ""
    var type: Int = 0
    var items: [T] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        response <- map["Response"]
        message <- map["Message"]
        type <- map["Type"]
        items <- map["Data"]
    }
}
