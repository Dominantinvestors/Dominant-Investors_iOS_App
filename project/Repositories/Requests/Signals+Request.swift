import UIKit

extension SignalModel {
    
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/signals/", method: .get, parameters: parameters)
    }
    
    func delete() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/signals/\(id)/", method: .delete)
    }
}
