import UIKit

extension PortfolioModel {
    
    static func get() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/portfolio/user/", method: .get)
    }
    
    static func assets() -> RequestProvider {
        let parameters: [String: Any] = ["limit": "100",
                                         "offset": "0"]
        return URLEncodingRequestBuilder(path: "/portfolio/user/assets/", method: .get, parameters: parameters)
    }
    
    static func search(by text: String) -> RequestProvider {
        let parameters: [String: Any] = ["q": text]
        return URLEncodingRequestBuilder(path: "/portfolio/user/assets/search-ticker/", method: .get, parameters: parameters)
    }
    
    static func buy(_ amount: String, _ asset: AssetsModel) -> RequestProvider {
        let parameters: [String: Any] = ["ticker": asset.ticker,
                                         "amount": amount,
                                         "price": asset.mktPrice]
        return URLEncodingRequestBuilder(path: "/transactions/buy/", method: .post, parameters: parameters)
    }
}
