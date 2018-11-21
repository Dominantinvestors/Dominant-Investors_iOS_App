import UIKit

extension PortfolioModel {
    
    static func get() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/portfolio/user/")
    }
    
    static func transactions() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0",
                                         "type": "b"]
        return URLEncodingRequestBuilder(path: "/portfolio/user/assets/", parameters: parameters)
    }
    
    static func transactions(_ forUser: Int) -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0",
                                         "type": "b"]
        return URLEncodingRequestBuilder(path: "/portfolio/user/assets/\(forUser)/", parameters: parameters)
    }
}
