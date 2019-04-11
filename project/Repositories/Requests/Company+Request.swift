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
    
    static func myCommented() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/investment-ideas/my-threads/")
    }
    
    func comments() -> RequestProvider {
        return JSONEncodingRequestBuilder(path: "/signals/investment-ideas/\(id)/comments/")
    }
    
    func add(_ comment: String) -> RequestProvider {
        let parameters: [String: Any] = ["text": comment]
        return JSONEncodingRequestBuilder(path: "/signals/investment-ideas/\(id)/comments/", method: .post, parameters: parameters)
    }
}

extension Company {
    
    func rate() -> RequestProvider {
        let parameters: [String: Any] = ["asset-type": type]
        return URLEncodingRequestBuilder(path: "/asset-rate/\(ticker)/", parameters: parameters)
    }
    
    func stockInfo(_ isChart: Bool) -> RequestProvider {
        let bar = UIApplication.shared.statusBarFrame.height
        let parameters = "width=\(UIScreen.main.bounds.width)&height=\(UIScreen.main.bounds.height - bar - 20)" + (isChart ? "&chart" : "")
        
        return URLEncodingRequestBuilder(path: "/stock-info/\(chart())/?\(parameters)")
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
                                         "asset_type": type]
        return JSONEncodingRequestBuilder(path: "/transactions/buy/", method: .post, parameters: parameters)
    }
    
    func sell(_ rate: String, _ amount: String) -> RequestProvider {
        let parameters: [String: Any] = ["ticker": ticker,
                                         "amount": amount,
                                         "price": rate,
                                         "asset_type": type]
        return JSONEncodingRequestBuilder(path: "/transactions/sell/", method: .post, parameters: parameters)
    }
    
}
