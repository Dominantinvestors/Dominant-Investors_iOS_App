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

    var isGrowing: Bool = false

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
        isGrowing <- map["stats.is_growing"]
        
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

struct StatusModel {
    let title: String
    let subtitle: String
}

extension CompanyModel {

    func status() -> [(StatusModel, StatusModel?)] {
        if isCrypto() {
            return cryptoStatus()
        } else {
            return companyStatus()
        }
    }
    
    func rating() -> [(StatusModel, StatusModel?)] {
        if isCrypto() {
            return cryptoRating()
        } else {
            return companyRating()
        }
    }
    
    func companyStatus() -> [(StatusModel, StatusModel?)] {
        var status: [(StatusModel, StatusModel?)] = []
        if let stats = stats {
            let marketCap = StatusModel(title: NSLocalizedString("Market Cap", comment: ""),
                                        subtitle: "\(stats.marketCap) Bil")
            let salesFQ3 = StatusModel(title: NSLocalizedString("Sales FQ3", comment: ""),
                                       subtitle: "\(stats.salesFQ3V) (\(stats.salesFQ3P)%)")
            
            status.append((marketCap, salesFQ3))
            
            let epsfq3 = StatusModel(title: NSLocalizedString("EPS FQ3", comment: ""),
                                     subtitle: "\(stats.epsFQ3V) (\(stats.epsFQ3P)%)")
            let peRatio = StatusModel(title: NSLocalizedString("P/E Ratio", comment: ""),
                                      subtitle: String(stats.peRatio))
            
            status.append((epsfq3, peRatio))
        }
        return status
    }
    
    func companyRating() -> [(StatusModel, StatusModel?)] {
        var rating: [(StatusModel, StatusModel?)] = []
        if let ratings = ratings {
            
            let compRating = StatusModel(title: NSLocalizedString("Comp Rating", comment: ""),
                                        subtitle: "\(ratings.comp) of 99")
            let groupRating = StatusModel(title: NSLocalizedString("Group Rat.", comment: ""),
                                       subtitle: "\(ratings.group) of 99")
            rating.append((compRating, groupRating))
            
            let epsRating = StatusModel(title: NSLocalizedString("EPS Rating", comment: ""),
                                         subtitle: "\(ratings.eps) of 99")
            let rsRating = StatusModel(title: NSLocalizedString("RS Rating", comment: ""),
                                          subtitle: "\(ratings.rs) of 99")
            rating.append((epsRating, rsRating))
        }
        return rating
    }
    
    
    func cryptoStatus() -> [(StatusModel, StatusModel?)] {
        var status: [(StatusModel, StatusModel?)] = []
        if let stats = stats {
            let marketCap = StatusModel(title: NSLocalizedString("Market Cap", comment: ""),
                                        subtitle: "\(stats.marketCap) Bil")
            let sirculation = StatusModel(title: NSLocalizedString("Sirculation", comment: ""),
                                       subtitle: "\(stats.circulating) Mil")
            
            status.append((marketCap, sirculation))
            
            let maxSupply = StatusModel(title: NSLocalizedString("Max Supply", comment: ""),
                                     subtitle: "\(stats.maxSupply) Mil")
            
            status.append((maxSupply, nil))
        }
        return status
    }
    
    func cryptoRating() -> [(StatusModel, StatusModel?)] {
        var rating: [(StatusModel, StatusModel?)] = []
        if let ratings = ratings {
            
            let technology = StatusModel(title: NSLocalizedString("Technology", comment: ""),
                                         subtitle: "\(ratings.technology) of 99")
            let command = StatusModel(title: NSLocalizedString("Command", comment: ""),
                                          subtitle: "\(ratings.command) of 99")
            rating.append((technology, command))
            
            let realisation = StatusModel(title: NSLocalizedString("Realisation", comment: ""),
                                        subtitle: "\(ratings.realization) of 99")
   
            rating.append((realisation, nil))
        }
        return rating
    }
}
