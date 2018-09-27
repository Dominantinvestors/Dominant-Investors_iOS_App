import Foundation
import ObjectMapper

class CompanyModel: Mappable, Company {
    
    var id: Int = 0
    var growthPotential: Int = 0
    var buyPoint: String = ""
    var targetPrice: String = ""
    var stopLoss: String = ""
    var description: String = ""
    var image: String?
    var logo: String?

    var type: String = ""
    var name: String = ""
    var ticker: String = ""
    var estimizeUrl: String?
    var estimizeEPSUrl: String?

    var ratings: RatingsModel?
    var stats: StatsModel?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["asset.type"]
        name <- map["asset.name"]
        ticker <- map["asset.ticker"]
        growthPotential <- map["growth_potential"]
        buyPoint <- map["buy_point"]
        targetPrice <- map["target_price"]
        stopLoss <- map["stop_loss"]
        description <- map["description"]
        image <- map["image"]
        logo <- map["logo"]
        
        estimizeUrl <- map["estimize_url"]
        estimizeEPSUrl <- map["estimize_eps_url"]
        
        ratings <- map["ratings"]
        stats <- map["stats"]

    }
    
    func isCrypto() -> Bool {
        return type == "c"
    }
}

class StatsModel: Mappable {

    var id: Int = 0

    var marketCap: Int = 0
    var epsFQ3V: Int = 0
    var epsFQ3P: Int = 0
    var salesFQ3V: Int = 0
    var salesFQ3P: Int = 0
    var peRatio: Int = 0
    var circulating: Int = 0
    var maxSupply: Int = 0
    var isGrowing: Bool = false

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        marketCap <- map["market_cap"]
        epsFQ3V <- map["eps_fq3_value"]
        epsFQ3P <- map["eps_fq3_percent"]
        salesFQ3V <- map["sales_fq3_value"]
        salesFQ3P <- map["sales_fq3_percent"]
        peRatio <- map["pe_ratio"]
        circulating <- map["circulating_supply"]
        maxSupply <- map["max_supply"]
        isGrowing <- map["is_growing"]
    }
}

class RatingsModel: Mappable {
    
    var id: Int = 0
    
    var comp: Int = 0
    var eps: Int = 0
    var group: Int = 0
    var rs: Int = 0
    var technology: Int = 0
    var command: Int = 0
    var realization: Int = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        comp <- map["comp"]
        eps <- map["eps"]
        group <- map["group"]
        rs <- map["rs"]
        technology <- map["technology"]
        command <- map["command"]
        realization <- map["realization"]
    }
}
