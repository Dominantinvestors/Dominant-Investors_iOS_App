import UIKit

extension CompanyModel {
   
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/", method: .get, parameters: parameters)
    }
    
    func add() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/\(id)/add-to-watchlist/", method: .post)
    }
    
    func createSignal(_ buyPoint: String, _ targetPrice: String, _ stopLoss: String) -> RequestProvider {
        let parameters: [String: Any] = ["asset_type": type,
                                         "ticker": ticker,
                                         "buy_point": buyPoint,
                                         "target_price": targetPrice,
                                         "stop_loss": stopLoss,
                                         "investment_idea": "0"]
        return URLEncodingRequestBuilder(path: "/signals/", method: .post, parameters: parameters)
    }
    
    static func search(by text: String) -> RequestProvider {
        let parameters: [String: Any] = ["q": text]
        return URLEncodingRequestBuilder(path: "/portfolio/user/assets/search-ticker/", method: .get, parameters: parameters)
    }
}
