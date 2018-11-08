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
        value <- (map["value"], MonayTransformator())
        buyingPower <- (map["buying_power"], MonayTransformator())
        total <- (map["total_gain_loss"], MonayTransformator())
        profit <- (map["avg_profit"], MonayTransformator())
    }
}

class TransactionModel: Mappable, Company {
    var id: Int = 0
    var ticker: String = ""
    var name: String = ""
    var type: String = ""

    var amount: String = ""
    var buyPoint: String = ""
    var rate: String = ""
    var profitPoints: String = ""
    var profitValue: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        ticker <- map["asset.ticker"]
        name <- map["asset.name"]
        type <- map["asset.type"]

        amount <- (map["amount"], MonayTransformator())

        buyPoint <- (map["price"], MonayTransformator())
        rate <- (map["mkt_price"], MonayTransformator())
        
        profitPoints <- (map["profit_points"], MonayTransformator())
        profitValue <- (map["profit_value"], MonayTransformator())
    }
}

class SearchAssetModel: Mappable, Company {
    
    var id: Int = 0
    var ticker: String = ""
    var name: String = ""
    var type: String = ""
    var rate: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        ticker <- map["ticker"]
        name <- map["name"]
        type <- map["category"]
        rate <- (map["rate"], MonayTransformator())
    }
}
