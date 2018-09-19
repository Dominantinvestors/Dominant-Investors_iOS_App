import UIKit
import ObjectMapper

class SignalModel: Mappable {
    
    var id: Int = 0
    var investmentIdea: Int = 0
    var buyPoint: String = ""
    var targetPrice: String = ""
    var mktPrice: String = ""
    var stopLoss: String = ""
    
    var type: String = ""
    var name: String = ""
    var ticker: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        type <- map["asset.type"]
        name <- map["asset.name"]
        ticker <- map["asset.ticker"]
        investmentIdea <- map["investment_idea"]
        buyPoint <- map["buy_point"]
        targetPrice <- map["target_price"]
        stopLoss <- map["stop_loss"]
    }
}
