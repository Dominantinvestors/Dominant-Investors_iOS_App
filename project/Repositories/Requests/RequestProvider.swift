import Alamofire

public protocol RequestProvider: URLRequestConvertible {
    var url: String { get }
    var path: String? { get }
    var keyPath: String? { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

class BaseRequestBuilder: RequestProvider {
    
    let url: String
    let path: String?
    let keyPath: String?
    let method: HTTPMethod
    let parameters: [String : Any]?
    
    func encoder() -> ParameterEncoding { fatalError() }
    
    init(url: String = Network.baseURL,
         path: String? = nil,
         keyPath: String?  = nil,
         method: HTTPMethod = .get,
         parameters: [String: Any]? = nil)
    {
        self.url = url
        self.path = path
        self.keyPath = keyPath
        self.method = method
        self.parameters = parameters
    }
    
    func asURL() throws -> URL {
        if let path = path {
            if path.hasPrefix("http") {
                return try path.asURL()
            } else {
                return try (url + path).asURL()
            }
        } else {
            return try url.asURL()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try self.asURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try encoder().encode(request, with: parameters)
    }
}

class URLEncodingRequestBuilder: BaseRequestBuilder {
    override func encoder() -> ParameterEncoding { return URLEncoding.default }
}

class JSONEncodingRequestBuilder: BaseRequestBuilder {
    override func encoder() -> ParameterEncoding { return JSONEncoding.default }
}
