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
    
    static func buy(_ amount: String, _ company: CompanyModel) -> RequestProvider {
        let parameters: [String: Any] = ["ticker": company.ticker,
                                         "amount": amount,
                                         "price": company.buyPoint]
        return URLEncodingRequestBuilder(path: "/transactions/buy/", method: .post, parameters: parameters)
    }
}
