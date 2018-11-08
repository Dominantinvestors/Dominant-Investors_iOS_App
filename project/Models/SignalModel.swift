import UIKit
import ObjectMapper

class SignalModel: Mappable {
    
    var id: Int = 0
    var investmentIdea: [String: Any]?
    var buyPoint: String = ""
    var targetPrice: String = ""
    var mktPrice: String = ""
    var stopLoss: String = ""
    
    var type: String = ""
    var name: String = ""
    var ticker: String = ""
    
    var user: UserModel?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["asset.type"]
        name <- map["asset.name"]
        ticker <- map["asset.ticker"]
        investmentIdea <- map["investment_idea"]
        buyPoint <- (map["buy_point"], MonayTransformator())
        targetPrice <- (map["target_price"], MonayTransformator())
        stopLoss <- (map["stop_loss"], MonayTransformator())
        mktPrice <- (map["mkt_price"], MonayTransformator())
        user <- map["user"]
    }
}
