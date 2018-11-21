import UIKit

extension CompanyModel {
   
    static func get() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/", parameters: parameters)
    }
    
    static func get(_ byID: Int) -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/\(byID)/")
    }
    
    func add() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/signals/investment-ideas/\(id)/add-to-watchlist/", method: .post)
    }
    
    static func search(by text: String) -> RequestProvider {
        let parameters: [String: Any] = ["q": text]
        return URLEncodingRequestBuilder(path: "/search-assets/", parameters: parameters)
    }
}

extension Company {
    
    func rate() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/asset-rate/\(ticker)/")
    }
    
    func createSignal(_ buyPoint: String, _ targetPrice: String, _ stopLoss: String) -> RequestProvider {
        let parameters: [String: Any] = ["asset_type": type,
                                         "ticker": ticker,
                                         "buy_point": buyPoint,
                                         "target_price": targetPrice,
                                         "stop_loss": stopLoss]
        return JSONEncodingRequestBuilder(path: "/signals/", method: .post, parameters: parameters)
    }
    
    func buy(_ rate: String, _ amount: String) -> RequestProvider {
        let parameters: [String: Any] = ["ticker": ticker,
                                         "amount": amount,
                                         "price": rate,
                                         "category": type]
        return JSONEncodingRequestBuilder(path: "/transactions/buy/", method: .post, parameters: parameters)
    }
    
    func sell(_ rate: String, _ amount: String) -> RequestProvider {
        let parameters: [String: Any] = ["ticker": ticker,
                                         "amount": amount,
                                         "price": rate,
                                         "category": type]
        return JSONEncodingRequestBuilder(path: "/transactions/sell/", method: .post, parameters: parameters)
    }
}
