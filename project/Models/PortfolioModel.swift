import Foundation
import ObjectMapper

class PortfolioModel: Mappable {
    
    var user: Int = 0
    var value: String = ""
    var buyingPower: String = ""
    var total: String = ""
    var profit: String = ""

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        user <- map["user"]
        value <- map["value"]
        buyingPower <- map["buying_power"]
        total <- map["total_gain_loss"]
        profit <- map["avg_profit"]
    }
}

class AssetsModel: Mappable {

    var id: Int = 0
    var ticker: String = ""
    var buyPoint: String = ""
    var mktPrice: String = ""
    var profitPoints: Int = 0
    var profitValue: Int = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        ticker <- map["asset.ticker"]
        buyPoint <- map["amount"]
        mktPrice <- map["buy_point"]
        profitPoints <- map["profit_points"]
        profitValue <- map["profit_value"]
    }
}
