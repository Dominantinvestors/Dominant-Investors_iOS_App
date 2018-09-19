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
    var profitPoints: String = ""
    var profitValue: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        ticker <- map["asset.ticker"]
        buyPoint <- map["buy_point"]
        
        mktPrice <- map["buying_power"]
        profitPoints <- map["total_gain_loss"]
        profitValue <- map["avg_profit"]
    }
}
