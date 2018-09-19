import UIKit

extension InvestorModel {
    
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/investors/", method: .get, parameters: parameters)
    }
}
