import Foundation
import ObjectMapper

protocol Company {
    var name: String { get }
    var ticker: String { get }
    var type: String { get }
    
    func isCrypto() -> Bool
    func chart() -> String
}

extension Company {
    
    func isCrypto() -> Bool {
        return type == "c"
    }
    
    func chart() -> String {
        if isCrypto() {
            return ticker + "USD"
        } else {
            return ticker
        }
    }
}

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

    var isGrowing: Bool = false

    var ratings: RatingsModel?
    var stats: StatsModel?

    var latestComment: Message?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["asset.type"]
        name <- map["asset.name"]
        ticker <- map["asset.ticker"]
        image <- map["image"]
        logo <- map["logo"]
        isGrowing <- map["stats.is_growing"]

        growthPotential <- map["growth_potential"]
        
        buyPoint <- (map["buy_point"], MonayTransformator())
        targetPrice <- (map["target_price"], MonayTransformator())
        stopLoss <- (map["stop_loss"], MonayTransformator())
        description <- (map["description"], MonayTransformator())
     
        estimizeUrl <- map["estimize_url"]
        estimizeEPSUrl <- map["estimize_eps_url"]
        
        ratings <- map["ratings"]
        stats <- map["stats"]
        latestComment <- map["latest_comment"]
    }
}

class Rate: Mappable {
    
    var rate: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        rate <- (map["current_rate"], MonayTransformator())
    }
}

class Widget: Mappable {
    
    var html: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        html <- map["widget_code"]
    }
}

class StatsModel: Mappable {

    var id: Int = 0

    var marketCap: String = ""
    var epsFQ3V: String = ""
    var epsFQ3P: String = ""
    var salesFQ3V: String = ""
    var salesFQ3P: String = ""
    var peRatio: String = ""
    var circulating: String = ""
    var maxSupply: String = ""

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        marketCap <- (map["market_cap"], MonayTransformator())
        epsFQ3V <- (map["eps_value"], MonayTransformator())
        epsFQ3P <- (map["eps_percent"], MonayTransformator())
        salesFQ3V <- (map["sales_value"], MonayTransformator())
        salesFQ3P <- (map["sales_percent"], MonayTransformator())
        peRatio <- (map["pe_ratio"], MonayTransformator())
        circulating <- (map["circulating_supply"], MonayTransformator())
        maxSupply <- (map["max_supply"], MonayTransformator())
    }
}

class RatingsModel: Mappable {
    
    var id: Int = 0
    
    var comp: String = ""
    var eps: String = ""
    var group: String = ""
    var rs: String = ""
    var technology: String = ""
    var command: String = ""
    var realization: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        comp <- (map["comp"], MonayTransformator())
        eps <- (map["eps"], MonayTransformator())
        group <- (map["group"], MonayTransformator())
        rs <- (map["rs"], MonayTransformator())
        technology <- (map["technology"], MonayTransformator())
        command <- (map["command"], MonayTransformator())
        realization <- (map["realization"], MonayTransformator())
    }
}

struct StatusModel {
    let title: String
    let subtitle: String
}

extension CompanyModel {

    func status() -> [StatusModel] {
        if isCrypto() {
            return cryptoStatus()
        } else {
            return companyStatus()
        }
    }
    
    func rating() -> [StatusModel] {
        if isCrypto() {
            return cryptoRating()
        } else {
            return companyRating()
        }
    }
    
    func companyStatus() -> [StatusModel] {
        var status: [StatusModel] = []
        if let stats = stats {
            let marketCap = StatusModel(title: NSLocalizedString("Market Cap", comment: ""),
                                        subtitle: "\(stats.marketCap)")
            let salesFQ3 = StatusModel(title: NSLocalizedString("Sales FQ", comment: ""),
                                       subtitle: "\(stats.salesFQ3V) (\(stats.salesFQ3P)%)")
            let epsfq3 = StatusModel(title: NSLocalizedString("EPS FQ", comment: ""),
                                     subtitle: "\(stats.epsFQ3V) (\(stats.epsFQ3P)%)")
            let peRatio = StatusModel(title: NSLocalizedString("P/E Ratio", comment: ""),
                                      subtitle: String(stats.peRatio))
            status.append(marketCap)
            status.append(salesFQ3)
            status.append(epsfq3)
            status.append(peRatio)
        }
        return status
    }
    
    func companyRating() -> [StatusModel] {
        var rating: [StatusModel] = []
        if let ratings = ratings {
            
            let compRating = StatusModel(title: NSLocalizedString("Comp Rating", comment: ""),
                                        subtitle: "\(ratings.comp) of 99")
            let groupRating = StatusModel(title: NSLocalizedString("Group Rat.", comment: ""),
                                       subtitle: "\(ratings.group) of 99")
            let epsRating = StatusModel(title: NSLocalizedString("EPS Rating", comment: ""),
                                         subtitle: "\(ratings.eps) of 99")
            let rsRating = StatusModel(title: NSLocalizedString("RS Rating", comment: ""),
                                          subtitle: "\(ratings.rs) of 99")
            rating.append(compRating)
            rating.append(groupRating)
            rating.append(epsRating)
            rating.append(rsRating)
        }
        return rating
    }
    
    
    func cryptoStatus() -> [StatusModel] {
        var status: [StatusModel] = []
        if let stats = stats {
            let marketCap = StatusModel(title: NSLocalizedString("Market Cap", comment: ""),
                                        subtitle: "\(stats.marketCap)")
            let sirculation = StatusModel(title: NSLocalizedString("Sirculation", comment: ""),
                                       subtitle: "\(stats.circulating)")
            let maxSupply = StatusModel(title: NSLocalizedString("Max Supply", comment: ""),
                                     subtitle: "\(stats.maxSupply)")
            status.append(marketCap)
            status.append(sirculation)
            status.append(maxSupply)
        }
        return status
    }
    
    func cryptoRating() -> [StatusModel] {
        var rating: [StatusModel] = []
        if let ratings = ratings {
            
            let technology = StatusModel(title: NSLocalizedString("Technology", comment: ""),
                                         subtitle: "\(ratings.technology) of 99")
            let command = StatusModel(title: NSLocalizedString("Command", comment: ""),
                                          subtitle: "\(ratings.command) of 99")
            let realisation = StatusModel(title: NSLocalizedString("Realisation", comment: ""),
                                        subtitle: "\(ratings.realization) of 99")
            rating.append(technology)
            rating.append(command)
            rating.append(realisation)
        }
        return rating
    }
}
