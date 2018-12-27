import UIKit

extension InvestorModel {
    
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/investors/", parameters: parameters)
    }
    
    static func get(by id: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/investors/\(id)/")
    }
    
    func follow() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/investors/\(id)/follow/", method: .post)
    }
    
    func unfollow() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/investors/\(id)/unfollow/", method: .post)
    }
}
