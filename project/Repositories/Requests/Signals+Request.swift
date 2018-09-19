import UIKit

extension SignalModel {
    
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/signals/", method: .get, parameters: parameters)
    }
    static func companies() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/", method: .get, parameters: parameters)
    }
    
    static func addCompany(_ company: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/\(company)/add-to-watchlist/", method: .post)
    }
}
