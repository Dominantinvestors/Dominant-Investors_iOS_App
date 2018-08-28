import Alamofire

class MainSessionManager: SessionManager {
    
    static func `default`(user: String, password: String) -> MainSessionManager{
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        let session = MainSessionManager(configuration: configuration)
        session.adapter = BasicSessionAdapter(user: user, password: password)
        
        return session
    }
    
    static func `default`(token: String?) -> MainSessionManager{
        let configuration = URLSessionConfiguration.default
    
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        let session = MainSessionManager(configuration: configuration)
        session.adapter = RFTSessionAdapter(token: token ?? "")
        
        return session
    }
}

struct BasicSessionAdapter: RequestAdapter {
    
    let user: String
    let password: String
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        guard let data = "\(user):\(password)".data(using: .utf8) else { return urlRequest }
        
        let credential = data.base64EncodedString(options: [])
        
        urlRequest.setValue("Basic \(credential)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}

struct RFTSessionAdapter: RequestAdapter {
    
    let token: String
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}

